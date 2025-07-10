import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/events/app_event_bus.dart';
import '../../../../../core/events/app_events.dart';
import '../../../../../core/utils/resource.dart';
import '../../../../auth/domain/repositories/user_repository.dart';
import '../../../domain/entities/carpool.dart';
import '../../../domain/entities/enum_carpool_status.dart';
import '../../../domain/entities/routing-matching/enum_trip_state.dart';
import '../../../domain/repositories/carpool_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  late StreamSubscription _eventBusSubscription;
  final UserRepository userRepository;
  final CarpoolRepository carpoolRepository;

  HomePageBloc({
    required this.userRepository,
    required this.carpoolRepository,
  }) : super(const HomePageState()) {
    on<TripStateChanged>(_onTripStateChanged);
    on<InitializeHomePage>(_onInitializeHomePage);

    add(const InitializeHomePage());

    _eventBusSubscription = AppEventBus().on<TripStateChangeRequested>().listen((event) {
      add(TripStateChanged(event.newState));
    });
  }

  void _onTripStateChanged(TripStateChanged event, Emitter<HomePageState> emit) {
    log('TAG: HomePageBloc: Trip state changed to: ${event.tripState}');
    emit(state.copyWith(currentTripState: event.tripState));
  }

  Future<void> _onInitializeHomePage(InitializeHomePage event, Emitter<HomePageState> emit) async {
    try {
      final user = await userRepository.getUserLocally();
      if (user == null) {
        log('TAG: HomePageBloc - No user found locally');
        return;
      }

      final result = await carpoolRepository.getActiveCarpoolByDriverId(user.id);

      switch (result) {
        case Success<Carpool>():
          final carpool = result.data;
          log('TAG: HomePageBloc - Active carpool found: ${carpool.id} with status: ${carpool.status}');

          // Map carpool status to trip state
          switch (carpool.status) {
            case CarpoolStatus.created:
              log('TAG: HomePageBloc - Carpool status created, staying in creating state');
              add(const TripStateChanged(TripState.waitingToStartCarpool));
              // Emit event for WaitingCarpoolBloc
              AppEventBus().emit(CarpoolCreatedSuccessfully(carpool.id));
              break;

            case CarpoolStatus.inProgress:
              log('TAG: HomePageBloc - Carpool status inProgress, transitioning to ongoingCarpool state');
              add(const TripStateChanged(TripState.ongoingCarpool));
              // Emit event for OnGoingCarpoolBloc
              AppEventBus().emit(CarpoolStartedSuccessfully(carpool.id));
              break;

            default:
              log('TAG: HomePageBloc - Carpool status ${carpool.status}, staying in creating state');
              break;
          }
          break;

        case Failure<Carpool>():
          log('TAG: HomePageBloc - No active carpool found: ${result.message}');
          break;

        case Loading<Carpool>():
          log('TAG: HomePageBloc - Loading active carpool...');
          break;
      }
    } catch (e) {
      log('TAG: HomePageBloc - Error initializing home page: $e');
    }
  }

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    return super.close();
  }
}