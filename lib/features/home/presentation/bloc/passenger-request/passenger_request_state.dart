import 'package:equatable/equatable.dart';

import '../../../domain/entities/enum_passenger_request_status.dart';
import '../../../domain/entities/passenger_request.dart';

class PassengerRequestState extends Equatable {
  // Main data
  final List<PassengerRequest> allRequests;
  final String? currentCarpoolId;

  // Loading states
  final bool isLoadingRequests;
  final bool isProcessingAccept;
  final bool isProcessingReject;
  final bool isBatchProcessing;
  final Set<String> processingRequestIds; // IDs of requests being processed

  // Dialog state for multiple requests management
  final bool isDialogOpen;
  final bool showFiltersSection;
  final String currentFilter; // 'all', 'pending', 'accepted', 'rejected'
  final String searchQuery;
  final String sortBy; // 'date', 'name', 'status', 'seats'
  final bool sortAscending;

  // Selection for batch operations
  final Set<String> selectedRequestIds;

  // Individual request details expansion
  final Set<String> expandedRequestIds;

  // Messages
  final String? successMessage;
  final String? errorMessage;

  const PassengerRequestState({
    this.allRequests = const [],
    this.currentCarpoolId,
    this.isLoadingRequests = false,
    this.isProcessingAccept = false,
    this.isProcessingReject = false,
    this.isBatchProcessing = false,
    this.processingRequestIds = const {},
    this.isDialogOpen = false,
    this.showFiltersSection = false,
    this.currentFilter = 'all',
    this.searchQuery = '',
    this.sortBy = 'date',
    this.sortAscending = false, // Most recent first by default
    this.selectedRequestIds = const {},
    this.expandedRequestIds = const {},
    this.successMessage,
    this.errorMessage,
  });

  // ========== COMPUTED PROPERTIES ==========

  /// Check if any action is being processed
  bool get isProcessing => isProcessingAccept || isProcessingReject || isLoadingRequests || isBatchProcessing;

  /// Check if can perform actions
  bool get canPerformActions => !isProcessing;

  /// Get filtered and sorted requests based on current filter and search
  List<PassengerRequest> get filteredRequests {
    var filtered = allRequests.where((request) {
      // Apply status filter
      bool matchesFilter = switch (currentFilter) {
        'pending' => request.status == PassengerRequestStatus.pending,
        'accepted' => request.status == PassengerRequestStatus.accepted,
        'rejected' => request.status == PassengerRequestStatus.rejected,
        'cancelled' => request.status == PassengerRequestStatus.cancelled,
        _ => true, // 'all'
      };

      // Apply search filter
      bool matchesSearch = searchQuery.isEmpty ||
          request.pickupLocation.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          request.pickupLocation.address.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = switch (sortBy) {
        'name' => a.pickupLocation.name.compareTo(b.pickupLocation.name),
        'status' => a.status.value.compareTo(b.status.value),
        'seats' => a.requestedSeats.compareTo(b.requestedSeats),
        _ => 0, // 'date' - would need createdAt field in PassengerRequest
      };

      return sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  /// Get pending requests only
  List<PassengerRequest> get pendingRequests {
    return allRequests.where((request) =>
    request.status == PassengerRequestStatus.pending
    ).toList();
  }

  /// Get accepted requests only
  List<PassengerRequest> get acceptedRequests {
    return allRequests.where((request) =>
    request.status == PassengerRequestStatus.accepted
    ).toList();
  }

  /// Get rejected requests only
  List<PassengerRequest> get rejectedRequests {
    return allRequests.where((request) =>
    request.status == PassengerRequestStatus.rejected
    ).toList();
  }

  /// Get cancelled requests only
  List<PassengerRequest> get cancelledRequests {
    return allRequests.where((request) =>
    request.status == PassengerRequestStatus.cancelled
    ).toList();
  }

  /// Count of pending requests (for badges/notifications)
  int get pendingRequestsCount => pendingRequests.length;

  /// Count of accepted requests (active passengers)
  int get acceptedRequestsCount => acceptedRequests.length;

  /// Count of rejected requests
  int get rejectedRequestsCount => rejectedRequests.length;

  /// Count of cancelled requests
  int get cancelledRequestsCount => cancelledRequests.length;

  /// Total seats requested by accepted passengers
  int get totalAcceptedSeats {
    return acceptedRequests.fold(0, (sum, request) => sum + request.requestedSeats);
  }

  /// Total seats requested by pending passengers
  int get totalPendingSeats {
    return pendingRequests.fold(0, (sum, request) => sum + request.requestedSeats);
  }

  /// Check if has any requests
  bool get hasRequests => allRequests.isNotEmpty;

  /// Check if has pending requests
  bool get hasPendingRequests => pendingRequests.isNotEmpty;

  /// Check if has any selected requests
  bool get hasSelectedRequests => selectedRequestIds.isNotEmpty;

  /// Check if all visible requests are selected
  bool get areAllFilteredRequestsSelected {
    final filteredIds = filteredRequests.map((r) => r.id).toSet();
    return filteredIds.isNotEmpty && selectedRequestIds.containsAll(filteredIds);
  }

  /// Check if specific request is being processed
  bool isRequestBeingProcessed(String requestId) {
    return processingRequestIds.contains(requestId);
  }

  /// Check if specific request is selected
  bool isRequestSelected(String requestId) {
    return selectedRequestIds.contains(requestId);
  }

  /// Check if specific request details are expanded
  bool isRequestExpanded(String requestId) {
    return expandedRequestIds.contains(requestId);
  }

  /// Get statistics for display
  Map<String, int> get requestStats => {
    'total': allRequests.length,
    'pending': pendingRequestsCount,
    'accepted': acceptedRequestsCount,
    'rejected': rejectedRequestsCount,
    'cancelled': cancelledRequestsCount,
  };

  // ========== COPY WITH ==========

  PassengerRequestState copyWith({
    List<PassengerRequest>? allRequests,
    String? currentCarpoolId,
    bool? isLoadingRequests,
    bool? isProcessingAccept,
    bool? isProcessingReject,
    bool? isBatchProcessing,
    Set<String>? processingRequestIds,
    bool? isDialogOpen,
    bool? showFiltersSection,
    String? currentFilter,
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
    Set<String>? selectedRequestIds,
    Set<String>? expandedRequestIds,
    String? successMessage,
    String? errorMessage,
  }) {
    return PassengerRequestState(
      allRequests: allRequests ?? this.allRequests,
      currentCarpoolId: currentCarpoolId ?? this.currentCarpoolId,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      isProcessingAccept: isProcessingAccept ?? this.isProcessingAccept,
      isProcessingReject: isProcessingReject ?? this.isProcessingReject,
      isBatchProcessing: isBatchProcessing ?? this.isBatchProcessing,
      processingRequestIds: processingRequestIds ?? this.processingRequestIds,
      isDialogOpen: isDialogOpen ?? this.isDialogOpen,
      showFiltersSection: showFiltersSection ?? this.showFiltersSection,
      currentFilter: currentFilter ?? this.currentFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedRequestIds: selectedRequestIds ?? this.selectedRequestIds,
      expandedRequestIds: expandedRequestIds ?? this.expandedRequestIds,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  /// Clear all messages (success and error)
  PassengerRequestState clearMessages() {
    return copyWith(
      successMessage: null,
      errorMessage: null,
    );
  }

  /// Close dialog and reset dialog-related state
  PassengerRequestState closeDialog() {
    return copyWith(
      isDialogOpen: false,
      showFiltersSection: false,
      currentFilter: 'all',
      searchQuery: '',
      selectedRequestIds: {},
      expandedRequestIds: {},
      successMessage: null,
      errorMessage: null,
    );
  }

  /// Reset processing state
  PassengerRequestState resetProcessing() {
    return copyWith(
      isProcessingAccept: false,
      isProcessingReject: false,
      isBatchProcessing: false,
      processingRequestIds: {},
    );
  }

  /// Add or update a request in the list
  PassengerRequestState updateRequest(PassengerRequest newRequest) {
    final updatedRequests = List<PassengerRequest>.from(allRequests);
    final existingIndex = updatedRequests.indexWhere(
            (request) => request.id == newRequest.id
    );

    if (existingIndex >= 0) {
      // Update existing request
      updatedRequests[existingIndex] = newRequest;
    } else {
      // Add new request at the beginning (most recent first)
      updatedRequests.insert(0, newRequest);
    }

    return copyWith(allRequests: updatedRequests);
  }

  /// Remove a request from the list
  PassengerRequestState removeRequest(String requestId) {
    final updatedRequests = allRequests.where(
            (request) => request.id != requestId
    ).toList();

    // Also remove from selections and expanded sets
    final updatedSelectedIds = Set<String>.from(selectedRequestIds);
    final updatedExpandedIds = Set<String>.from(expandedRequestIds);
    updatedSelectedIds.remove(requestId);
    updatedExpandedIds.remove(requestId);

    return copyWith(
      allRequests: updatedRequests,
      selectedRequestIds: updatedSelectedIds,
      expandedRequestIds: updatedExpandedIds,
    );
  }

  /// Toggle request selection
  PassengerRequestState toggleRequestSelection(String requestId) {
    final updatedSelectedIds = Set<String>.from(selectedRequestIds);

    if (updatedSelectedIds.contains(requestId)) {
      updatedSelectedIds.remove(requestId);
    } else {
      updatedSelectedIds.add(requestId);
    }

    return copyWith(selectedRequestIds: updatedSelectedIds);
  }

  /// Toggle request details expansion
  PassengerRequestState toggleRequestExpansion(String requestId) {
    final updatedExpandedIds = Set<String>.from(expandedRequestIds);

    if (updatedExpandedIds.contains(requestId)) {
      updatedExpandedIds.remove(requestId);
    } else {
      updatedExpandedIds.add(requestId);
    }

    return copyWith(expandedRequestIds: updatedExpandedIds);
  }

  /// Select all filtered requests
  PassengerRequestState selectAllFilteredRequests() {
    final filteredIds = filteredRequests.map((r) => r.id).toSet();
    final updatedSelectedIds = Set<String>.from(selectedRequestIds);
    updatedSelectedIds.addAll(filteredIds);

    return copyWith(selectedRequestIds: updatedSelectedIds);
  }

  /// Deselect all requests
  PassengerRequestState deselectAllRequests() {
    return copyWith(selectedRequestIds: {});
  }

  @override
  List<Object?> get props => [
    allRequests,
    currentCarpoolId,
    isLoadingRequests,
    isProcessingAccept,
    isProcessingReject,
    isBatchProcessing,
    processingRequestIds,
    isDialogOpen,
    showFiltersSection,
    currentFilter,
    searchQuery,
    sortBy,
    sortAscending,
    selectedRequestIds,
    expandedRequestIds,
    successMessage,
    errorMessage,
  ];
}