import 'package:equatable/equatable.dart';

abstract class WaitingCarpoolEvent extends Equatable {
  const WaitingCarpoolEvent();

  @override
  List<Object?> get props => [];
}

class LoadCarpool extends WaitingCarpoolEvent {
  final String carpoolId;

  const LoadCarpool(this.carpoolId);

  @override
  List<Object?> get props => [carpoolId];
}

class GenerateRoute extends WaitingCarpoolEvent {
  const GenerateRoute();
}

class StartCarpool extends WaitingCarpoolEvent {
  const StartCarpool();
}

class CancelCarpool extends WaitingCarpoolEvent {
  const CancelCarpool();
}

class RefreshCarpoolData extends WaitingCarpoolEvent {
  const RefreshCarpoolData();
}

class GetUserLocation extends WaitingCarpoolEvent {}