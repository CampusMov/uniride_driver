import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(const HomePageState()) {
    on<TripStateChanged>(_onTripStateChanged);
  }

  void _onTripStateChanged(TripStateChanged event, Emitter<HomePageState> emit) {
    log('TAG: HomePageBloc: Trip state changed to: ${event.tripState}');
    emit(state.copyWith(currentTripState: event.tripState));
  }
}