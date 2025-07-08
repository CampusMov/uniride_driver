import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/constants/api_constants.dart';

import '../../../../../core/events/app_event_bus.dart';
import '../../../../../core/events/app_events.dart';
import '../../../../../core/utils/resource.dart';
import '../../../../../core/websocket/websocket_manager.dart';
import '../../../domain/entities/passenger_request.dart';
import '../../../domain/repositories/passenger_request_repository.dart';
import 'passenger_request_event.dart';
import 'passenger_request_state.dart';

class PassengerRequestBloc extends Bloc<PassengerRequestEvent, PassengerRequestState> {
  final PassengerRequestRepository passengerRequestRepository;
  late StreamSubscription _eventBusSubscription;

  PassengerRequestBloc({
    required this.passengerRequestRepository,
  }) : super(const PassengerRequestState()) {
    _registerEventHandlers();
    _initializeEventBusListener();
  }

  // ========== INITIALIZATION ==========

  void _registerEventHandlers() {
    // Data management events
    on<LoadPassengerRequests>(_onLoadRequests);
    on<RefreshPassengerRequests>(_onRefreshRequests);
    on<AddPassengerRequest>(_onAddRequest);
    on<UpdatePassengerRequest>(_onUpdateRequest);
    on<RemovePassengerRequest>(_onRemoveRequest);

    // Action events
    on<AcceptPassengerRequest>(_onAcceptRequest);
    on<RejectPassengerRequest>(_onRejectRequest);
    on<BatchAcceptRequests>(_onBatchAccept);
    on<BatchRejectRequests>(_onBatchReject);

    // Dialog management events
    on<OpenRequestsManagementDialog>(_onOpenDialog);
    on<CloseRequestsManagementDialog>(_onCloseDialog);
    on<ChangeRequestsFilter>(_onChangeFilter);
    on<ToggleFiltersSection>(_onToggleFilters);
    on<SearchRequests>(_onSearchRequests);
    on<SortRequests>(_onSortRequests);

    // Selection events
    on<ToggleRequestSelection>(_onToggleSelection);
    on<ClearRequestSelections>(_onClearSelections);
    on<ToggleRequestDetails>(_onToggleDetails);

    // Utility events
    on<ClearMessages>(_onClearMessages);
    on<MarkRequestAsViewed>(_onMarkAsViewed);

    _eventBusSubscription = AppEventBus().on<CarpoolCreatedSuccessfully>().listen((event) {
      add(LoadPassengerRequests(event.carpoolId));
    });
  }

  void _initializeEventBusListener() {
    _eventBusSubscription = AppEventBus().on<PassengerRequestReceived>().listen((event) {
      add(AddPassengerRequest(event.passengerRequest));
    });
  }

  // ========== DATA MANAGEMENT ==========

  void _onLoadRequests(LoadPassengerRequests event, Emitter<PassengerRequestState> emit) async {
    emit(state.copyWith(
      isLoadingRequests: true,
      currentCarpoolId: event.carpoolId,
      errorMessage: null,
    ));

    try {
      log('TAG: PassengerRequestBloc - Loading passenger requests for carpool: ${event.carpoolId}');

      final result = await passengerRequestRepository.getPassengerRequestsByCarpoolId(event.carpoolId);

      switch (result) {
        case Success<List<PassengerRequest>>():
          final requests = result.data;
          log('TAG: PassengerRequestBloc - Loaded ${requests.length} passenger requests');

          emit(state.copyWith(
            allRequests: requests,
            isLoadingRequests: false,
            successMessage: 'Solicitudes cargadas exitosamente',
          ));

          await _initializeWebSocketForCarpool(event.carpoolId);
          break;

        case Failure<List<PassengerRequest>>():
          log('TAG: PassengerRequestBloc - Failed to load requests: ${result.message}');
          emit(state.copyWith(
            isLoadingRequests: false,
            errorMessage: 'Error al cargar solicitudes: ${result.message}',
          ));
          break;

        case Loading<dynamic>():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: PassengerRequestBloc - Error loading requests: $e');
      emit(state.copyWith(
        isLoadingRequests: false,
        errorMessage: 'Error inesperado al cargar solicitudes: ${e.toString()}',
      ));
    }
  }

  Future<void> _initializeWebSocketForCarpool(String carpoolId) async {
    try {
      final webSocketManager = WebSocketManager();
      final wsUrl = '${ApiConstants.webSocketUrl}${ApiConstants.routingMatchingServiceName}/ws';

      log('TAG: PassengerRequestBloc - Initializing WebSocket for carpool: $carpoolId');

      // Connect to matching-routing service if not already connected
      final connectionStatus = webSocketManager.getConnectionStatus(ApiConstants.routingMatchingServiceName);

      if (connectionStatus != WebSocketConnectionStatus.connected) {
        log('TAG: PassengerRequestBloc - Connecting to WebSocket: $wsUrl');

        await webSocketManager.connectToService(
          serviceName: ApiConstants.routingMatchingServiceName,
          wsUrl: wsUrl,
        );

        // Wait a bit for connection to establish
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Subscribe to passenger requests for this carpool
      log('TAG: PassengerRequestBloc - Subscribing to passenger requests for carpool: $carpoolId');
      webSocketManager.subscribeToPassengerRequestInCarpool(carpoolId);

      log('TAG: PassengerRequestBloc - WebSocket initialized successfully for carpool: $carpoolId');

    } catch (e) {
      log('TAG: PassengerRequestBloc - Error initializing WebSocket: $e');
      // Don't emit error state, WebSocket is optional
    }
  }

  void _onRefreshRequests(RefreshPassengerRequests event, Emitter<PassengerRequestState> emit) {
    if (state.currentCarpoolId != null) {
      add(LoadPassengerRequests(state.currentCarpoolId!));
    }
  }

  void _onAddRequest(AddPassengerRequest event, Emitter<PassengerRequestState> emit) {
    log('TAG: PassengerRequestBloc - Adding new passenger request: ${event.passengerRequest.id}');
    emit(state.updateRequest(event.passengerRequest));
  }

  void _onUpdateRequest(UpdatePassengerRequest event, Emitter<PassengerRequestState> emit) {
    log('TAG: PassengerRequestBloc - Updating passenger request: ${event.passengerRequest.id} to status: ${event.passengerRequest.status}');
    emit(state.updateRequest(event.passengerRequest));
  }

  void _onRemoveRequest(RemovePassengerRequest event, Emitter<PassengerRequestState> emit) {
    log('TAG: PassengerRequestBloc - Removing passenger request: ${event.passengerRequestId}');
    emit(state.removeRequest(event.passengerRequestId));
  }

  // ========== SINGLE ACTIONS ==========

  void _onAcceptRequest(AcceptPassengerRequest event, Emitter<PassengerRequestState> emit) async {
    if (state.isProcessing) {
      log('TAG: PassengerRequestBloc - Cannot accept, already processing');
      return;
    }

    // Add request ID to processing set
    final updatedProcessingIds = Set<String>.from(state.processingRequestIds);
    updatedProcessingIds.add(event.passengerRequestId);

    emit(state.copyWith(
      isProcessingAccept: true,
      processingRequestIds: updatedProcessingIds,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      log('TAG: PassengerRequestBloc - Accepting passenger request: ${event.passengerRequestId}');

      await _sendWebSocketMessage('/app/passenger-request/accept', {
        'passengerRequestId': event.passengerRequestId,
        'message': event.message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      // Remove request ID from processing set
      final finalProcessingIds = Set<String>.from(state.processingRequestIds);
      finalProcessingIds.remove(event.passengerRequestId);

      emit(state.copyWith(
        isProcessingAccept: false,
        processingRequestIds: finalProcessingIds,
        successMessage: 'Solicitud aceptada exitosamente',
      ));

      log('TAG: PassengerRequestBloc - Passenger request accepted successfully');

    } catch (e) {
      log('TAG: PassengerRequestBloc - Error accepting passenger request: $e');

      final finalProcessingIds = Set<String>.from(state.processingRequestIds);
      finalProcessingIds.remove(event.passengerRequestId);

      emit(state.copyWith(
        isProcessingAccept: false,
        processingRequestIds: finalProcessingIds,
        errorMessage: 'Error al aceptar la solicitud: ${e.toString()}',
      ));
    }
  }

  void _onRejectRequest(RejectPassengerRequest event, Emitter<PassengerRequestState> emit) async {
    if (state.isProcessing) {
      log('TAG: PassengerRequestBloc - Cannot reject, already processing');
      return;
    }

    // Add request ID to processing set
    final updatedProcessingIds = Set<String>.from(state.processingRequestIds);
    updatedProcessingIds.add(event.passengerRequestId);

    emit(state.copyWith(
      isProcessingReject: true,
      processingRequestIds: updatedProcessingIds,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      log('TAG: PassengerRequestBloc - Rejecting passenger request: ${event.passengerRequestId}');

      await _sendWebSocketMessage('/app/passenger-request/reject', {
        'passengerRequestId': event.passengerRequestId,
        'reason': event.reason,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      // Remove request ID from processing set
      final finalProcessingIds = Set<String>.from(state.processingRequestIds);
      finalProcessingIds.remove(event.passengerRequestId);

      emit(state.copyWith(
        isProcessingReject: false,
        processingRequestIds: finalProcessingIds,
        successMessage: 'Solicitud rechazada',
      ));

      log('TAG: PassengerRequestBloc - Passenger request rejected successfully');

    } catch (e) {
      log('TAG: PassengerRequestBloc - Error rejecting passenger request: $e');

      final finalProcessingIds = Set<String>.from(state.processingRequestIds);
      finalProcessingIds.remove(event.passengerRequestId);

      emit(state.copyWith(
        isProcessingReject: false,
        processingRequestIds: finalProcessingIds,
        errorMessage: 'Error al rechazar la solicitud: ${e.toString()}',
      ));
    }
  }

  // ========== BATCH ACTIONS ==========

  void _onBatchAccept(BatchAcceptRequests event, Emitter<PassengerRequestState> emit) async {
    if (state.isProcessing || event.requestIds.isEmpty) {
      log('TAG: PassengerRequestBloc - Cannot batch accept, already processing or no requests');
      return;
    }

    emit(state.copyWith(
      isBatchProcessing: true,
      processingRequestIds: event.requestIds.toSet(),
      errorMessage: null,
      successMessage: null,
    ));

    try {
      log('TAG: PassengerRequestBloc - Batch accepting ${event.requestIds.length} requests');

      await _sendWebSocketMessage('/app/passenger-request/batch-accept', {
        'passengerRequestIds': event.requestIds,
        'message': event.message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      emit(state.copyWith(
        isBatchProcessing: false,
        processingRequestIds: {},
        selectedRequestIds: {}, // Clear selections after batch operation
        successMessage: '${event.requestIds.length} solicitudes aceptadas exitosamente',
      ));

      log('TAG: PassengerRequestBloc - Batch accept completed successfully');

    } catch (e) {
      log('TAG: PassengerRequestBloc - Error in batch accept: $e');

      emit(state.copyWith(
        isBatchProcessing: false,
        processingRequestIds: {},
        errorMessage: 'Error al aceptar solicitudes en lote: ${e.toString()}',
      ));
    }
  }

  void _onBatchReject(BatchRejectRequests event, Emitter<PassengerRequestState> emit) async {
    if (state.isProcessing || event.requestIds.isEmpty) {
      log('TAG: PassengerRequestBloc - Cannot batch reject, already processing or no requests');
      return;
    }

    emit(state.copyWith(
      isBatchProcessing: true,
      processingRequestIds: event.requestIds.toSet(),
      errorMessage: null,
      successMessage: null,
    ));

    try {
      log('TAG: PassengerRequestBloc - Batch rejecting ${event.requestIds.length} requests');

      await _sendWebSocketMessage('/app/passenger-request/batch-reject', {
        'passengerRequestIds': event.requestIds,
        'reason': event.reason,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      emit(state.copyWith(
        isBatchProcessing: false,
        processingRequestIds: {},
        selectedRequestIds: {}, // Clear selections after batch operation
        successMessage: '${event.requestIds.length} solicitudes rechazadas',
      ));

      log('TAG: PassengerRequestBloc - Batch reject completed successfully');

    } catch (e) {
      log('TAG: PassengerRequestBloc - Error in batch reject: $e');

      emit(state.copyWith(
        isBatchProcessing: false,
        processingRequestIds: {},
        errorMessage: 'Error al rechazar solicitudes en lote: ${e.toString()}',
      ));
    }
  }

  // ========== DIALOG MANAGEMENT ==========

  void _onOpenDialog(OpenRequestsManagementDialog event, Emitter<PassengerRequestState> emit) {
    log('TAG: PassengerRequestBloc - Opening requests management dialog');

    emit(state.copyWith(
      isDialogOpen: true,
      currentFilter: 'pending', // Default to pending requests
      searchQuery: '',
      selectedRequestIds: {},
      expandedRequestIds: {},
      successMessage: null,
      errorMessage: null,
    ));
  }

  void _onCloseDialog(CloseRequestsManagementDialog event, Emitter<PassengerRequestState> emit) {
    log('TAG: PassengerRequestBloc - Closing requests management dialog');
    emit(state.closeDialog());
  }

  void _onChangeFilter(ChangeRequestsFilter event, Emitter<PassengerRequestState> emit) {
    log('TAG: PassengerRequestBloc - Changing filter to: ${event.filter}');

    emit(state.copyWith(
      currentFilter: event.filter,
      selectedRequestIds: {}, // Clear selections when changing filter
    ));
  }

  void _onToggleFilters(ToggleFiltersSection event, Emitter<PassengerRequestState> emit) {
    emit(state.copyWith(
      showFiltersSection: !state.showFiltersSection,
    ));

    log('TAG: PassengerRequestBloc - Filters section ${state.showFiltersSection ? 'shown' : 'hidden'}');
  }

  void _onSearchRequests(SearchRequests event, Emitter<PassengerRequestState> emit) {
    emit(state.copyWith(
      searchQuery: event.searchQuery,
      selectedRequestIds: {}, // Clear selections when searching
    ));

    log('TAG: PassengerRequestBloc - Searching requests with query: "${event.searchQuery}"');
  }

  void _onSortRequests(SortRequests event, Emitter<PassengerRequestState> emit) {
    emit(state.copyWith(
      sortBy: event.sortBy,
      sortAscending: event.ascending,
    ));

    log('TAG: PassengerRequestBloc - Sorting requests by: ${event.sortBy} (${event.ascending ? 'ascending' : 'descending'})');
  }

  // ========== SELECTION MANAGEMENT ==========

  void _onToggleSelection(ToggleRequestSelection event, Emitter<PassengerRequestState> emit) {
    emit(state.toggleRequestSelection(event.passengerRequestId));
    log('TAG: PassengerRequestBloc - Toggled selection for request: ${event.passengerRequestId}');
  }

  void _onClearSelections(ClearRequestSelections event, Emitter<PassengerRequestState> emit) {
    emit(state.deselectAllRequests());
    log('TAG: PassengerRequestBloc - Cleared all selections');
  }

  void _onToggleDetails(ToggleRequestDetails event, Emitter<PassengerRequestState> emit) {
    emit(state.toggleRequestExpansion(event.passengerRequestId));
    log('TAG: PassengerRequestBloc - Toggled details for request: ${event.passengerRequestId}');
  }

  // ========== UTILITY METHODS ==========

  void _onClearMessages(ClearMessages event, Emitter<PassengerRequestState> emit) {
    emit(state.clearMessages());
  }

  void _onMarkAsViewed(MarkRequestAsViewed event, Emitter<PassengerRequestState> emit) {
    // TODO: Implement mark as viewed logic if needed
    log('TAG: PassengerRequestBloc - Marking request as viewed: ${event.passengerRequestId}');
  }

  // ========== HELPER METHODS ==========

  Future<void> _sendWebSocketMessage(String destination, Map<String, dynamic> payload) async {
    final webSocketManager = WebSocketManager();

    /*await webSocketManager.sendMessage(
      serviceName: '${ApiConstants.webSocketUrl}${ApiConstants.routingMatchingServiceName}',
      destination: destination,
      payload: payload,
    );*/
  }

  // ========== CLEANUP ==========

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    return super.close();
  }
}