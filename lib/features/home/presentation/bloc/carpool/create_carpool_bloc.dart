import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/home/domain/repositories/carpool_repository.dart';
import 'package:uniride_driver/features/profile/domain/entities/vehicle.dart';
import 'package:uniride_driver/features/profile/domain/entities/class_schedule.dart';
import 'package:uniride_driver/features/profile/domain/repositories/profile_class_schedule_repository.dart';
import 'package:uniride_driver/features/home/data/repositories/location_repository.dart';

import '../../../../auth/domain/repositories/user_repository.dart';
import '../../../../shared/domain/entities/location.dart';
import 'create_carpool_event.dart';
import 'create_carpool_state.dart';

class CreateCarpoolBloc extends Bloc<CreateCarpoolEvent, CreateCarpoolState> {
  final CarpoolRepository carpoolRepository;
  final UserRepository userRepository;
  final ProfileClassScheduleRepository profileClassScheduleRepository;
  final LocationRepository locationRepository;

  CreateCarpoolBloc({
    required this.carpoolRepository,
    required this.userRepository,
    required this.profileClassScheduleRepository,
    required this.locationRepository,
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
    on<ClearCarpoolCreationResult>(_onClearCarpoolCreationResult);

    // Class Schedule Dialog Events
    on<OpenDialogToSelectClassSchedule>(_onOpenDialogToSelectClassSchedule);
    on<CloseDialogToSelectClassSchedule>(_onCloseDialogToSelectClassSchedule);
    on<ClassScheduleSelected>(_onClassScheduleSelected);
    on<ClassScheduleSearchChanged>(_onClassScheduleSearchChanged);
    on<LoadClassSchedules>(_onLoadClassSchedules);

    // Origin Location Dialog Events
    on<OpenDialogToSelectOriginLocation>(_onOpenDialogToSelectOriginLocation);
    on<CloseDialogToSelectOriginLocation>(_onCloseDialogToSelectOriginLocation);
    on<OriginLocationSelected>(_onOriginLocationSelected);
    on<OriginLocationSearchChanged>(_onOriginLocationSearchChanged);
    on<OriginLocationCleared>(_onOriginLocationCleared);

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

  // Class Schedule Dialog Events
  void _onOpenDialogToSelectClassSchedule(OpenDialogToSelectClassSchedule event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(
      isSelectClassScheduleDialogOpen: true,
      classScheduleSearchQuery: '',
    ));
    // Load class schedules when dialog opens
    add(const LoadClassSchedules());
  }

  void _onCloseDialogToSelectClassSchedule(CloseDialogToSelectClassSchedule event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(
      isSelectClassScheduleDialogOpen: false,
      classScheduleSearchQuery: '',
      allClassSchedules: [],
      filteredClassSchedules: [],
      isLoadingClassSchedules: false,
    ));
  }

  void _onClassScheduleSelected(ClassScheduleSelected event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(
      classSchedule: event.classSchedule,
      isSelectClassScheduleDialogOpen: false,
      classScheduleSearchQuery: '',
      allClassSchedules: [],
      filteredClassSchedules: [],
    ));
  }

  void _onClassScheduleSearchChanged(ClassScheduleSearchChanged event, Emitter<CreateCarpoolState> emit) {
    final query = event.searchTerm.toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(
        classScheduleSearchQuery: event.searchTerm,
        filteredClassSchedules: state.allClassSchedules,
      ));
    } else {
      final filtered = state.allClassSchedules.where((schedule) {
        return schedule.courseName.toLowerCase().contains(query) ||
            schedule.locationName.toLowerCase().contains(query) ||
            schedule.selectedDay.showDay().toLowerCase().contains(query);
      }).toList();

      emit(state.copyWith(
        classScheduleSearchQuery: event.searchTerm,
        filteredClassSchedules: filtered,
      ));
    }
  }

  void _onLoadClassSchedules(LoadClassSchedules event, Emitter<CreateCarpoolState> emit) async {
    if (state.user == null) {
      log('TAG: CreateCarpoolBloc: Cannot load class schedules - user is null');
      return;
    }

    emit(state.copyWith(isLoadingClassSchedules: true));

    try {
      final result = await profileClassScheduleRepository.getClassScheduleByProfileId(state.user!.id);

      switch (result) {
        case Success<List<ClassSchedule>>():
          log('TAG: CreateCarpoolBloc: Class schedules loaded successfully: ${result.data.length} schedules');
          emit(state.copyWith(
            allClassSchedules: result.data,
            filteredClassSchedules: result.data,
            isLoadingClassSchedules: false,
          ));
          break;
        case Failure<List<ClassSchedule>>():
          log('TAG: CreateCarpoolBloc: Failed to load class schedules: ${result.message}');
          emit(state.copyWith(
            allClassSchedules: [],
            filteredClassSchedules: [],
            isLoadingClassSchedules: false,
          ));
          break;
        case Loading<List<ClassSchedule>>():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: CreateCarpoolBloc: Error loading class schedules: $e');
      emit(state.copyWith(
        allClassSchedules: [],
        filteredClassSchedules: [],
        isLoadingClassSchedules: false,
      ));
    }
  }

  // Origin Location Dialog Events
  void _onOpenDialogToSelectOriginLocation(OpenDialogToSelectOriginLocation event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(isSelectOriginLocationDialogOpen: true));
  }

  void _onCloseDialogToSelectOriginLocation(CloseDialogToSelectOriginLocation event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(
      isSelectOriginLocationDialogOpen: false,
      locationPredictions: [],
    ));
  }

  void _onOriginLocationSelected(OriginLocationSelected event, Emitter<CreateCarpoolState> emit) async {
    try {
      final location = await locationRepository.getLocationByPlaceId(event.originLocationPrediction.placeId);

      if (location != null) {
        final selectedLocation = Location(
          name: event.originLocationPrediction.description,
          latitude: double.parse(location.latitude),
          longitude: double.parse(location.longitude),
          address: location.address,
        );

        log('TAG: CreateCarpoolBloc: Origin location selected: ${selectedLocation.address}');
        log('TAG: CreateCarpoolBloc: Coordinates: ${selectedLocation.latitude}, ${selectedLocation.longitude}');

        emit(state.copyWith(
          originLocation: selectedLocation,
          isSelectOriginLocationDialogOpen: false,
          locationPredictions: [],
        ));
      } else {
        log('TAG: CreateCarpoolBloc: Could not get origin location details from Place Details API');
      }
    } catch (e) {
      log('TAG: CreateCarpoolBloc: Error getting origin place details: $e');
    }
  }

  void _onOriginLocationSearchChanged(OriginLocationSearchChanged event, Emitter<CreateCarpoolState> emit) async {
    if (event.searchTerm.isEmpty) {
      emit(state.copyWith(locationPredictions: []));
      return;
    }

    try {
      final predictions = await locationRepository.searchLocation(event.searchTerm);
      log('TAG: CreateCarpoolBloc: Found ${predictions.length} location predictions for origin');
      emit(state.copyWith(locationPredictions: predictions));
    } catch (e) {
      log('TAG: CreateCarpoolBloc: Error getting origin location predictions: $e');
      emit(state.copyWith(locationPredictions: []));
    }
  }

  void _onOriginLocationCleared(OriginLocationCleared event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(
      originLocation: null,
      locationPredictions: [],
    ));
  }

  void _onClearCarpoolCreationResult(ClearCarpoolCreationResult event, Emitter<CreateCarpoolState> emit) {
    emit(state.copyWith(carpoolCreationResult: null));
  }

  Future<void> _onSaveCarpool(SaveCarpool event, Emitter<CreateCarpoolState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      carpoolCreationResult: null, // Reset previous result
    ));

    try {
      final result = await carpoolRepository.createCarpool(state.toDomain());

      switch (result) {
        case Success<Carpool>():
          log('TAG: CreateCarpoolBloc: Carpool created successfully: ${result.data.id}');
          emit(state.copyWith(
            isLoading: false,
            carpoolCreationResult: result,
          ));
          break;
        case Failure<Carpool>():
          log('TAG: CreateCarpoolBloc: Failed to create carpool: ${result.message}');
          emit(state.copyWith(
            isLoading: false,
            carpoolCreationResult: result,
          ));
          break;
        case Loading<Carpool>():
          log('TAG: CreateCarpoolBloc: Creating carpool...');
          break;
      }
    } catch (e) {
      log('TAG: CreateCarpoolBloc: Error saving carpool: $e');
      emit(state.copyWith(
        isLoading: false,
        carpoolCreationResult: Failure('Error inesperado: ${e.toString()}'),
      ));
    }
  }
}