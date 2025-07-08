import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/home/domain/entities/routing-matching/enum_trip_state.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object?> get props => [];
}

class TripStateChanged extends HomePageEvent {
  final TripState tripState;

  const TripStateChanged(this.tripState);

  @override
  List<Object?> get props => [tripState];
}