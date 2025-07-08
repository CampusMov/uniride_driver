import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/home/domain/entities/route.dart';

import '../../../../../core/events/app_event_bus.dart';
import '../../../../../core/events/app_events.dart';
import '../../../../../core/utils/resource.dart';
import '../../../domain/entities/routing-matching/enum_trip_state.dart';
import '../../../domain/repositories/carpool_repository.dart';
import '../../../domain/repositories/route_repository.dart';
import 'waiting_carpool_event.dart';
import 'waiting_carpool_state.dart';

class WaitingCarpoolBloc extends Bloc<WaitingCarpoolEvent, WaitingCarpoolState> {
  final CarpoolRepository carpoolRepository;
  final RouteRepository routeRepository;
  late StreamSubscription _eventBusSubscription;

  WaitingCarpoolBloc({
    required this.carpoolRepository,
    required this.routeRepository,
  }) : super(const WaitingCarpoolState()) {
    on<LoadCarpool>(_onLoadCarpool);
    on<GenerateRoute>(_onGenerateRoute);
    on<StartCarpool>(_onStartCarpool);
    on<CancelCarpool>(_onCancelCarpool);
    on<RefreshCarpoolData>(_onRefreshCarpoolData);

    _eventBusSubscription = AppEventBus().on<CarpoolCreatedSuccessfully>().listen((event) {
      add(LoadCarpool(event.carpoolId));
    });
  }

  void _onLoadCarpool(LoadCarpool event, Emitter<WaitingCarpoolState> emit) async {
    emit(state.copyWith(isLoadingCarpool: true, errorMessage: null));

    try {
      log('TAG: WaitingCarpoolBloc - Loading carpool with ID: ${event.carpoolId}');

      final result = await carpoolRepository.getCarpoolById(event.carpoolId);

      switch (result) {
        case Success<Carpool>():
          final carpool = result.data;
          log('TAG: WaitingCarpoolBloc - Carpool loaded successfully: ${carpool.id}');

          emit(state.copyWith(
            isLoadingCarpool: false,
            carpool: carpool,
            successMessage: 'Carpool cargado exitosamente',
          ));

          // Automatically generate route after loading carpool
          add(const GenerateRoute());
          break;

        case Failure<Carpool>():
          log('TAG: WaitingCarpoolBloc - Failed to load carpool: ${result.message}');
          emit(state.copyWith(
            isLoadingCarpool: false,
            errorMessage: 'Error al cargar carpool: ${result.message}',
          ));
          break;

        case Loading<dynamic>():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error loading carpool: $e');
      emit(state.copyWith(
        isLoadingCarpool: false,
        errorMessage: 'Error inesperado al cargar carpool: ${e.toString()}',
      ));
    }
  }

  void _onGenerateRoute(GenerateRoute event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool cargado para generar ruta'));
      return;
    }

    emit(state.copyWith(isLoadingRoute: true, errorMessage: null));

    try {
      final carpool = state.carpool!;

      log('TAG: WaitingCarpoolBloc - Generating route from (${carpool.origin.latitude}, ${carpool.origin.longitude}) to (${carpool.destination.latitude}, ${carpool.destination.longitude})');

      final result = await routeRepository.getRoute(
        carpool.origin.latitude,
        carpool.origin.longitude,
        carpool.destination.latitude,
        carpool.destination.longitude,
      );

      switch (result) {
        case Success<Route>():
          final route = result.data;
          final coordinates = route.intersections.map((intersection) => intersection.toLatLng()).toList();

          log('TAG: WaitingCarpoolBloc - Route generated successfully with ${coordinates.length} points');

          emit(state.copyWith(
            isLoadingRoute: false,
            route: route,
            routeCoordinates: coordinates,
            successMessage: 'Ruta generada exitosamente',
          ));

          AppEventBus().emit(AddPolylineRequested(
            coordinates: coordinates,
            polylineId: 'carpool_route',
            color: const Color(0xFF2196F3),
            width: 5,
          ));

          log('TAG: WaitingCarpoolBloc - Polyline sent to MapBloc');
          break;

        case Failure<Route>():
          log('TAG: WaitingCarpoolBloc - Failed to generate route: ${result.message}');
          emit(state.copyWith(
            isLoadingRoute: false,
            errorMessage: 'Error al generar ruta: ${result.message}',
          ));
          break;

        case Loading<dynamic>():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error generating route: $e');
      emit(state.copyWith(
        isLoadingRoute: false,
        errorMessage: 'Error inesperado al generar ruta: ${e.toString()}',
      ));
    }
  }

  void _onStartCarpool(StartCarpool event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool para iniciar'));
      return;
    }

    emit(state.copyWith(isStartingCarpool: true, errorMessage: null));

    try {
      // TODO: Implement start carpool logic
      // This might involve updating carpool status to IN_PROGRESS

      log('TAG: WaitingCarpoolBloc - Starting carpool: ${state.carpool!.id}');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        isStartingCarpool: false,
        successMessage: 'Carpool iniciado exitosamente',
      ));

      AppEventBus().emit(const TripStateChangeRequested(TripState.ongoingCarpool));

      log('TAG: WaitingCarpoolBloc - Carpool started successfully');
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error starting carpool: $e');
      emit(state.copyWith(
        isStartingCarpool: false,
        errorMessage: 'Error al iniciar carpool: ${e.toString()}',
      ));
    }
  }

  void _onCancelCarpool(CancelCarpool event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool para cancelar'));
      return;
    }

    emit(state.copyWith(isCancellingCarpool: true, errorMessage: null));

    try {
      // TODO: Implement cancel carpool logic
      // This might involve updating carpool status to CANCELLED

      log('TAG: WaitingCarpoolBloc - Cancelling carpool: ${state.carpool!.id}');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Clear polyline from map via EventBus
      AppEventBus().emit(const RemovePolylineRequested('carpool_route'));

      emit(state.copyWith(
        isCancellingCarpool: false,
        successMessage: 'Carpool cancelado exitosamente',
      ));

      // Emit event to change trip state back to creating
      AppEventBus().emit(const TripStateChangeRequested(TripState.creatingCarpool));

      log('TAG: WaitingCarpoolBloc - Carpool cancelled successfully');
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error cancelling carpool: $e');
      emit(state.copyWith(
        isCancellingCarpool: false,
        errorMessage: 'Error al cancelar carpool: ${e.toString()}',
      ));
    }
  }

  void _onRefreshCarpoolData(RefreshCarpoolData event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool != null) {
      add(LoadCarpool(state.carpool!.id));
    }
  }

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    return super.close();
  }
}