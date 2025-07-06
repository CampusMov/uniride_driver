import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/home/domain/repositories/carpool_repository.dart';
import 'package:uniride_driver/features/profile/domain/entities/vehicle.dart';

import '../../../../auth/domain/repositories/user_repository.dart';
import 'create_carpool_event.dart';
import 'create_carpool_state.dart';

class CreateCarpoolBloc extends Bloc<CreateCarpoolEvent, CreateCarpoolState> {
  final CarpoolRepository carpoolRepository;
  final UserRepository userRepository;

  CreateCarpoolBloc({
    required this.carpoolRepository,
    required this.userRepository,
  }) : super(const CreateCarpoolState()) {
    on<LoadUserLocally>(_onLoadUserLocally);
    on<LoadVehicleLocally>(_onLoadVehicleLocally);
    on<MaxPassengersChanged>(_onMaxPassengersChanged);
    on<IncreaseMaxPassengers>(_onIncreaseMaxPassengers);
    on<DecreaseMaxPassengers>(_onDecreaseMaxPassengers);
    on<RadiusChanged>(_onRadiusChanged);
    on<IncreaseRadius>(_onIncreaseRadius);
    on<DecreaseRadius>(_onDecreaseRadius);
    on<ClassScheduleChanged>(_onClassScheduleChanged);
    on<OriginLocationChanged>(_onOriginLocationChanged);
    on<SaveCarpool>(_onSaveCarpool);

    add(const LoadUserLocally());
    add(const LoadVehicleLocally());
  }

  void _onLoadUserLocally(LoadUserLocally event, Emitter<CreateCarpoolState> emit) async {
    try {
      final result = await userRepository.getUserLocally();
      if (result != null) {
        log('TAG: CreateCarpoolBloc: User loaded locally: ${result.email}');
        emit(state.copyWith(
          user: result,
        ));
      }
    } catch (e) {
      log('TAG: CreateCarpoolBloc: Error loading user locally: $e');
    }
  }

  void _onLoadVehicleLocally(LoadVehicleLocally event, Emitter<CreateCarpoolState> emit) async {
    // TODO: Implement vehicle loading logic
    emit(state.copyWith(vehicle: Vehicle(brand: "brand", model: "model", year: 0, licensePlate: "licensePlate", ownerId: "ownerId")));
  }

  void _onMaxPassengersChanged(MaxPassengersChanged event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(maxPassengers: event.maxPassengers));
  }

  void _onIncreaseMaxPassengers(IncreaseMaxPassengers event, Emitter<CreateCarpoolState> emit) {
    final newMaxPassengers = state.maxPassengers + 1;
    emit(state.copyWith(maxPassengers: newMaxPassengers));
  }

  void _onDecreaseMaxPassengers(DecreaseMaxPassengers event, Emitter<CreateCarpoolState> emit) {
    final newMaxPassengers = state.maxPassengers > 1 ? state.maxPassengers - 1 : 1;
    emit(state.copyWith(maxPassengers: newMaxPassengers));
  }

  void _onRadiusChanged(RadiusChanged event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(radius: event.radius));
  }

  void _onIncreaseRadius(IncreaseRadius event, Emitter<CreateCarpoolState> emit) {
    final newRadius = state.radius + 1;
    emit(state.copyWith(radius: newRadius));
  }

  void _onDecreaseRadius(DecreaseRadius event, Emitter<CreateCarpoolState> emit) {
    final newRadius = state.radius > 1 ? state.radius - 1 : 1;
    emit(state.copyWith(radius: newRadius));
  }

  void _onClassScheduleChanged(ClassScheduleChanged event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(classSchedule: event.classSchedule));
  }

  void _onOriginLocationChanged(OriginLocationChanged event, Emitter<CreateCarpoolState> emit) {
    // TODO: Get the query predictions from the API place details
    //emit(state.copyWith(originLocation: event.originLocation));
  }

  Future<void> _onSaveCarpool(SaveCarpool event, Emitter<CreateCarpoolState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await carpoolRepository.createCarpool(state.toDomain());
      switch (result) {
        case Success<Carpool>():
          log('TAG: CreateCarpoolBloc: Carpool created successfully');
          emit(state.copyWith(isLoading: false));
          break;
        case Failure<Carpool>():
          log('TAG: CreateCarpoolBloc: Failed to create carpool: ${result.message}');
          emit(state.copyWith(isLoading: false));
          break;
        case Loading<Carpool>():
          log('TAG: CreateCarpoolBloc: Creating carpool...');
          break;
      }
    } catch (e) {
      log('TAG: CreateCarpoolBloc: Error saving carpool: $e');
      emit(state.copyWith(isLoading: false));
    }
  }
}
