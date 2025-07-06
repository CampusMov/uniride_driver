import 'package:equatable/equatable.dart';

import '../../../../profile/domain/entities/class_schedule.dart';
import '../../../domain/entities/place_prediction.dart';

abstract class CreateCarpoolEvent extends Equatable {
  const CreateCarpoolEvent();

  @override
  List<Object?> get props => [];
}

// User loading event
class LoadUserLocally extends CreateCarpoolEvent {
  const LoadUserLocally();
}

// Vehicle loading event
class LoadVehicleLocally extends CreateCarpoolEvent {
  const LoadVehicleLocally();
}

// Carpool form events
class MaxPassengersChanged extends CreateCarpoolEvent {
  final int maxPassengers;

  const MaxPassengersChanged(this.maxPassengers);

  @override
  List<Object?> get props => [maxPassengers];
}

class IncreaseMaxPassengers extends CreateCarpoolEvent {
  const IncreaseMaxPassengers();
}

class DecreaseMaxPassengers extends CreateCarpoolEvent {
  const DecreaseMaxPassengers();
}

class RadiusChanged extends CreateCarpoolEvent {
  final int radius;

  const RadiusChanged(this.radius);

  @override
  List<Object?> get props => [radius];
}

class IncreaseRadius extends CreateCarpoolEvent {
  const IncreaseRadius();
}

class DecreaseRadius extends CreateCarpoolEvent {
  const DecreaseRadius();
}

class ClassScheduleChanged extends CreateCarpoolEvent {
  final ClassSchedule classSchedule;

  const ClassScheduleChanged(this.classSchedule);

  @override
  List<Object?> get props => [classSchedule];
}

class OriginLocationChanged extends CreateCarpoolEvent {
  final String query;

  const OriginLocationChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// Carpool save event
class SaveCarpool extends CreateCarpoolEvent {
  const SaveCarpool();
}

// Select class schedule events
class OpenDialogToSelectClassSchedule extends CreateCarpoolEvent {
  const OpenDialogToSelectClassSchedule();
}

class CloseDialogToSelectClassSchedule extends CreateCarpoolEvent {
  const CloseDialogToSelectClassSchedule();
}

class ClassScheduleSelected extends CreateCarpoolEvent {
  final ClassSchedule classSchedule;

  const ClassScheduleSelected(this.classSchedule);

  @override
  List<Object?> get props => [classSchedule];
}

class ClassScheduleSearchChanged extends CreateCarpoolEvent {
  final String searchTerm;

  const ClassScheduleSearchChanged(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class LoadClassSchedules extends CreateCarpoolEvent {
  const LoadClassSchedules();
}

// Select origin location events
class OpenDialogToSelectOriginLocation extends CreateCarpoolEvent {
  const OpenDialogToSelectOriginLocation();
}

class CloseDialogToSelectOriginLocation extends CreateCarpoolEvent {
  const CloseDialogToSelectOriginLocation();
}

class OriginLocationSelected extends CreateCarpoolEvent {
  final Prediction originLocationPrediction;

  const OriginLocationSelected(this.originLocationPrediction);

  @override
  List<Object?> get props => [originLocationPrediction];
}

class OriginLocationSearchChanged extends CreateCarpoolEvent {
  final String searchTerm;

  const OriginLocationSearchChanged(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class OriginLocationCleared extends CreateCarpoolEvent {
  const OriginLocationCleared();
}