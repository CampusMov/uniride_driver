import 'package:equatable/equatable.dart';

import '../../../domain/entities/passenger_request.dart';

abstract class PassengerRequestEvent extends Equatable {
  const PassengerRequestEvent();

  @override
  List<Object?> get props => [];
}

/// Load passenger requests for a specific carpool
class LoadPassengerRequests extends PassengerRequestEvent {
  final String carpoolId;

  const LoadPassengerRequests(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

/// Refresh passenger requests
class RefreshPassengerRequests extends PassengerRequestEvent {
  const RefreshPassengerRequests();
}

/// Accept a passenger request
class AcceptPassengerRequest extends PassengerRequestEvent {
  final String passengerRequestId;
  final String? message; // Optional message to passenger

  const AcceptPassengerRequest({
    required this.passengerRequestId,
    this.message,
  });

  @override
  List<Object?> get props => [passengerRequestId, message];
}

/// Reject a passenger request
class RejectPassengerRequest extends PassengerRequestEvent {
  final String passengerRequestId;
  final String? reason; // Optional reason for rejection

  const RejectPassengerRequest({
    required this.passengerRequestId,
    this.reason,
  });

  @override
  List<Object?> get props => [passengerRequestId, reason];
}

/// Add new passenger request (from WebSocket)
class AddPassengerRequest extends PassengerRequestEvent {
  final PassengerRequest passengerRequest;

  const AddPassengerRequest(this.passengerRequest);

  @override
  List<Object?> get props => [passengerRequest];
}

/// Update existing passenger request (from WebSocket)
class UpdatePassengerRequest extends PassengerRequestEvent {
  final PassengerRequest passengerRequest;

  const UpdatePassengerRequest(this.passengerRequest);

  @override
  List<Object?> get props => [passengerRequest];
}

/// Remove passenger request
class RemovePassengerRequest extends PassengerRequestEvent {
  final String passengerRequestId;

  const RemovePassengerRequest(this.passengerRequestId);

  @override
  List<Object?> get props => [passengerRequestId];
}

// ========== DIALOG EVENTS (Multiple Requests Management) ==========

/// Open dialog to manage all passenger requests
class OpenRequestsManagementDialog extends PassengerRequestEvent {
  const OpenRequestsManagementDialog();
}

/// Close requests management dialog
class CloseRequestsManagementDialog extends PassengerRequestEvent {
  const CloseRequestsManagementDialog();
}

/// Change filter for displaying requests
class ChangeRequestsFilter extends PassengerRequestEvent {
  final String filter; // 'all', 'pending', 'accepted', 'rejected'

  const ChangeRequestsFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Toggle filter section visibility
class ToggleFiltersSection extends PassengerRequestEvent {
  const ToggleFiltersSection();
}

/// Search/filter requests by passenger name or other criteria
class SearchRequests extends PassengerRequestEvent {
  final String searchQuery;

  const SearchRequests(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

/// Sort requests by criteria (date, name, status, etc.)
class SortRequests extends PassengerRequestEvent {
  final String sortBy; // 'date', 'name', 'status', 'seats'
  final bool ascending;

  const SortRequests({
    required this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [sortBy, ascending];
}

/// Select/unselect multiple requests for batch operations
class ToggleRequestSelection extends PassengerRequestEvent {
  final String passengerRequestId;

  const ToggleRequestSelection(this.passengerRequestId);

  @override
  List<Object?> get props => [passengerRequestId];
}

/// Clear all selections
class ClearRequestSelections extends PassengerRequestEvent {
  const ClearRequestSelections();
}

/// Batch accept selected requests
class BatchAcceptRequests extends PassengerRequestEvent {
  final List<String> requestIds;
  final String? message;

  const BatchAcceptRequests({
    required this.requestIds,
    this.message,
  });

  @override
  List<Object?> get props => [requestIds, message];
}

/// Batch reject selected requests
class BatchRejectRequests extends PassengerRequestEvent {
  final List<String> requestIds;
  final String? reason;

  const BatchRejectRequests({
    required this.requestIds,
    this.reason,
  });

  @override
  List<Object?> get props => [requestIds, reason];
}

/// Clear success/error messages
class ClearMessages extends PassengerRequestEvent {
  const ClearMessages();
}

/// Mark request as viewed/read
class MarkRequestAsViewed extends PassengerRequestEvent {
  final String passengerRequestId;

  const MarkRequestAsViewed(this.passengerRequestId);

  @override
  List<Object?> get props => [passengerRequestId];
}

/// Expand/collapse request details in the dialog
class ToggleRequestDetails extends PassengerRequestEvent {
  final String passengerRequestId;

  const ToggleRequestDetails(this.passengerRequestId);

  @override
  List<Object?> get props => [passengerRequestId];
}