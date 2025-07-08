import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/events/app_event_bus.dart';
import '../../../../../core/events/app_events.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  late StreamSubscription _eventBusSubscription;

  HomePageBloc() : super(const HomePageState()) {
    on<TripStateChanged>(_onTripStateChanged);

    _eventBusSubscription = AppEventBus().on<TripStateChangeRequested>().listen((event) {
      add(TripStateChanged(event.newState));
    });
  }

  void _onTripStateChanged(TripStateChanged event, Emitter<HomePageState> emit) {
    log('TAG: HomePageBloc: Trip state changed to: ${event.tripState}');
    emit(state.copyWith(currentTripState: event.tripState));
  }

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    return super.close();
  }
}