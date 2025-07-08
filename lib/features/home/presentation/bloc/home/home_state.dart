import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/home/domain/entities/routing-matching/enum_trip_state.dart';

class HomePageState extends Equatable {
  final TripState currentTripState;

  const HomePageState({
    this.currentTripState = TripState.creatingCarpool,
  });

  HomePageState copyWith({
    TripState? currentTripState,
  }) {
    return HomePageState(
      currentTripState: currentTripState ?? this.currentTripState,
    );
  }

  @override
  List<Object?> get props => [currentTripState];
}