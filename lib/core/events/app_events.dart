import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uniride_driver/features/home/domain/entities/routing-matching/enum_trip_state.dart';
import 'package:uniride_driver/features/home/domain/entities/way_point.dart';

import '../../features/home/domain/entities/passenger_request.dart';

// Events for the application, which are used to trigger changes in the state of the app.
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

// Events related to the Home Page
class TripStateChangeRequested extends AppEvent {
  final TripState newState;

  const TripStateChangeRequested(this.newState);

  @override
  List<Object?> get props => [newState];
}

// Events related to Carpool Management
class CarpoolCreatedSuccessfully extends AppEvent {
  final String carpoolId;

  const CarpoolCreatedSuccessfully(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

class CarpoolStartRequested extends AppEvent {
  final String carpoolId;

  const CarpoolStartRequested(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

class CarpoolCancelRequested extends AppEvent {
  final String carpoolId;

  const CarpoolCancelRequested(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

class CarpoolStartedSuccessfully extends AppEvent {
  final String carpoolId;

  const CarpoolStartedSuccessfully(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

// Events related to Map Management
class AddPolylineRequested extends AppEvent {
  final List<LatLng> coordinates;
  final String polylineId;
  final Color color;
  final int width;

  const AddPolylineRequested({
    required this.coordinates,
    required this.polylineId,
    this.color = const Color(0xFF2196F3),
    this.width = 5,
  });

  @override
  List<Object?> get props => [coordinates, polylineId, color, width];
}

class RemovePolylineRequested extends AppEvent {
  final String polylineId;

  const RemovePolylineRequested(this.polylineId);

  @override
  List<Object?> get props => [polylineId];
}

class ClearAllPolylinesRequested extends AppEvent {
  const ClearAllPolylinesRequested();
}

// Events related to WebSocket for each microservice
class WebSocketServiceConnected extends AppEvent {
  final String serviceName;

  const WebSocketServiceConnected(this.serviceName);

  @override
  List<Object?> get props => [serviceName];
}

class WebSocketServiceDisconnected extends AppEvent {
  final String serviceName;

  const WebSocketServiceDisconnected(this.serviceName);

  @override
  List<Object?> get props => [serviceName];
}

class WebSocketServiceError extends AppEvent {
  final String serviceName;
  final String error;

  const WebSocketServiceError(this.serviceName, this.error);

  @override
  List<Object?> get props => [serviceName, error];
}

// Events related to Passenger Requests
class PassengerRequestReceived extends AppEvent {
  final PassengerRequest passengerRequest;

  const PassengerRequestReceived(this.passengerRequest);

  @override
  List<Object?> get props => [passengerRequest];
}

class PassengerRequestAccepted extends AppEvent {
  const PassengerRequestAccepted();
}

// Events related to Routes Carpool and Waypoints
class WaypointsUpdated extends AppEvent {
  final List<WayPoint> waypoints;

  const WaypointsUpdated(this.waypoints);

  @override
  List<Object?> get props => [waypoints];
}