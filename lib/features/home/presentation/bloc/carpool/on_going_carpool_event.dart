import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

abstract class OnGoingCarpoolEvent extends Equatable {
  const OnGoingCarpoolEvent();

  @override
  List<Object?> get props => [];
}

class InitializeOnGoingCarpool extends OnGoingCarpoolEvent {
  final String carpoolId;

  const InitializeOnGoingCarpool(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}


class LoadOnGoingCarpoolData extends OnGoingCarpoolEvent {
  final String carpoolId;

  const LoadOnGoingCarpoolData(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

class StartLocationTracking extends OnGoingCarpoolEvent {
  const StartLocationTracking();
}

class StopLocationTracking extends OnGoingCarpoolEvent {
  const StopLocationTracking();
}

class UpdateDriverLocation extends OnGoingCarpoolEvent {
  final Location location;

  const UpdateDriverLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class OnGoingCarpoolErrorOccurred extends OnGoingCarpoolEvent {
  final String message;

  const OnGoingCarpoolErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}

class FinishCarpool extends OnGoingCarpoolEvent {
  const FinishCarpool();
}