// ongoing_carpool_bloc.dart
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:uniride_driver/core/events/app_event_bus.dart';
import 'package:uniride_driver/core/events/app_events.dart';
import 'package:uniride_driver/features/home/domain/repositories/carpool_repository.dart';
import 'package:uniride_driver/features/home/domain/repositories/route_repository.dart';
import 'package:uniride_driver/features/home/domain/repositories/route_carpool_repository.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';
import 'package:uniride_driver/core/utils/resource.dart';

import 'on_going_carpool_event.dart';
import 'on_going_carpool_state.dart';

class OnGoingCarpoolBloc extends Bloc<OnGoingCarpoolEvent, OnGoingCarpoolState> {
  final CarpoolRepository carpoolRepository;
  final RouteRepository routeRepository;
  final RouteCarpoolRepository routeCarpoolRepository;

  late StreamSubscription _eventBusSubscription;
  Timer? _locationUpdateTimer;
  StreamSubscription<Position>? _positionStreamSubscription;

  String? _currentRouteId;
  bool _isLocationTrackingActive = false;

  OnGoingCarpoolBloc({
    required this.carpoolRepository,
    required this.routeRepository,
    required this.routeCarpoolRepository,
  }) : super(const OnGoingCarpoolState()) {
    on<InitializeOnGoingCarpool>(_onInitializeOnGoingCarpool);
    on<LoadOnGoingCarpoolData>(_onLoadOnGoingCarpoolData);
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
    on<UpdateDriverLocation>(_onUpdateDriverLocation);
    on<OnGoingCarpoolErrorOccurred>(_onOnGoingCarpoolErrorOccurred);
    on<FinishCarpool>(_onFinishCarpool);

    _subscribeToAppEvents();
  }

  void _subscribeToAppEvents() {
    _eventBusSubscription = AppEventBus().on<CarpoolStartedSuccessfully>().listen((event) {
      log('TAG: OnGoingCarpoolBloc - Received CarpoolStartedSuccessfully with ID: ${event.carpoolId}');
      add(InitializeOnGoingCarpool(event.carpoolId));
    });
  }

  Future<void> _onInitializeOnGoingCarpool(InitializeOnGoingCarpool event, Emitter<OnGoingCarpoolState> emit) async {
    log('TAG: OnGoingCarpoolBloc - Initializing ongoing carpool with ID: ${event.carpoolId}');

    emit(state.copyWith(
      isLoadingCarpool: true,
      isLoadingRouteCarpool: true,
      errorMessage: null,
    ));

    add(LoadOnGoingCarpoolData(event.carpoolId));

    add(const StartLocationTracking());
  }

  Future<void> _onLoadOnGoingCarpoolData(LoadOnGoingCarpoolData event, Emitter<OnGoingCarpoolState> emit) async {
    try {
      log('TAG: OnGoingCarpoolBloc - Loading carpool data for ID: ${event.carpoolId}');

      final carpoolResult = await carpoolRepository.getCarpoolById(event.carpoolId);

      switch (carpoolResult) {
        case Success():
          final carpool = carpoolResult.data;
          log('TAG: OnGoingCarpoolBloc - Successfully loaded carpool: ${carpool.id}');

          emit(state.copyWith(
            isLoadingCarpool: false,
            carpool: carpool,
          ));

          final routeCarpoolResult = await routeCarpoolRepository.getRouteByCarpoolId(event.carpoolId);

          switch (routeCarpoolResult) {
            case Success():
              final routeCarpool = routeCarpoolResult.data;
              log('TAG: OnGoingCarpoolBloc - Successfully loaded route carpool: ${routeCarpool.id}');
              _currentRouteId = routeCarpool.id;

              emit(state.copyWith(
                isLoadingRouteCarpool: false,
                routeCarpool: routeCarpool,
              ));

              // 3. Calcular ruta real para obtener distancia y duración
              emit(state.copyWith(isLoadingRoute: true));

              final routeResult = await routeRepository.getRoute(
                carpool.origin.latitude,
                carpool.origin.longitude,
                carpool.destination.latitude,
                carpool.destination.longitude,
              );

              switch (routeResult) {
                case Success():
                  final route = routeResult.data;
                  log('TAG: OnGoingCarpoolBloc - Successfully calculated route with distance: ${route.totalDistance}m');

                  // Calcular estimaciones
                  final distanceKm = route.totalDistance / 1000;
                  final durationMinutes = (distanceKm / 30) * 60; // 30 km/h velocidad promedio
                  final estimatedArrival = DateTime.now().add(Duration(minutes: durationMinutes.round()));

                  emit(state.copyWith(
                    isLoadingRoute: false,
                    route: route,
                    estimatedArrivalTime: estimatedArrival,
                    estimatedDurationText: _formatDuration(durationMinutes.round()),
                    estimatedDistanceText: _formatDistance(distanceKm),
                    successMessage: 'Carpool cargado exitosamente',
                  ));
                  break;

                case Failure():
                  log('TAG: OnGoingCarpoolBloc - Error calculating route: ${routeResult.message}');
                  emit(state.copyWith(
                    isLoadingRoute: false,
                    errorMessage: 'Error al calcular ruta: ${routeResult.message}',
                  ));
                  break;

                case Loading():
                // Already loading
                  break;
              }
              break;

            case Failure():
              log('TAG: OnGoingCarpoolBloc - Error loading route carpool: ${routeCarpoolResult.message}');
              emit(state.copyWith(
                isLoadingRouteCarpool: false,
                errorMessage: 'Error al cargar route carpool: ${routeCarpoolResult.message}',
              ));
              break;

            case Loading():
            // Already loading
              break;
          }
          break;

        case Failure():
          log('TAG: OnGoingCarpoolBloc - Error loading carpool data: ${carpoolResult.message}');
          emit(state.copyWith(
            isLoadingCarpool: false,
            errorMessage: 'Error al cargar carpool: ${carpoolResult.message}',
          ));
          break;

        case Loading():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: OnGoingCarpoolBloc - Unexpected error loading carpool data: $e');
      emit(state.copyWith(
        isLoadingCarpool: false,
        isLoadingRouteCarpool: false,
        isLoadingRoute: false,
        errorMessage: 'Error inesperado al cargar datos: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStartLocationTracking(StartLocationTracking event, Emitter<OnGoingCarpoolState> emit) async {
    if (_isLocationTrackingActive) {
      log('TAG: OnGoingCarpoolBloc - Location tracking already active');
      return;
    }

    try {
      log('TAG: OnGoingCarpoolBloc - Starting location tracking');

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final permissionResult = await Geolocator.requestPermission();
        if (permissionResult == LocationPermission.denied ||
            permissionResult == LocationPermission.deniedForever) {
          emit(state.copyWith(errorMessage: 'Permiso de ubicación denegado'));
          return;
        }
      }

      _isLocationTrackingActive = true;


      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
            (Position position) {
          final location = Location(
            name: 'Current Location',
            latitude: position.latitude,
            longitude: position.longitude,
            address: '',
          );
          add(UpdateDriverLocation(location));
        },
        onError: (error) {
          log('TAG: OnGoingCarpoolBloc - Location stream error: $error');
          emit(state.copyWith(errorMessage: 'Error de seguimiento de ubicación: ${error.toString()}'));
        },
      );

      _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: 3),
            (timer) {
          if (!_isLocationTrackingActive) {
            timer.cancel();
          }
        },
      );

      emit(state.copyWith(isLocationTracking: true));
      log('TAG: OnGoingCarpoolBloc - Location tracking started successfully');
    } catch (e) {
      log('TAG: OnGoingCarpoolBloc - Error starting location tracking: $e');
      emit(state.copyWith(errorMessage: 'Error al iniciar seguimiento: ${e.toString()}'));
    }
  }

  Future<void> _onStopLocationTracking(StopLocationTracking event, Emitter<OnGoingCarpoolState> emit) async {
    log('TAG: OnGoingCarpoolBloc - Stopping location tracking');

    _isLocationTrackingActive = false;
    _locationUpdateTimer?.cancel();
    _positionStreamSubscription?.cancel();

    emit(state.copyWith(isLocationTracking: false));
  }

  Future<void> _onUpdateDriverLocation(UpdateDriverLocation event, Emitter<OnGoingCarpoolState> emit) async {
    if (_currentRouteId == null) {
      log('TAG: OnGoingCarpoolBloc - No route ID available for location update');
      return;
    }

    try {
      log('TAG: OnGoingCarpoolBloc - Updating driver location: ${event.location.latitude}, ${event.location.longitude}');

      // Calcular si está cerca del destino
      bool isNear = false;
      if (state.hasCarpool) {
        isNear = _calculateDistanceToDestination(event.location, state.carpool!.destination) <= 200;
      }

      // Actualizar ubicación en el backend
      final result = await routeCarpoolRepository.updateRouteCurrentLocation(
        _currentRouteId!,
        event.location,
      );

      switch (result) {
        case Success():
          final updatedRoute = result.data;
          emit(state.copyWith(
            routeCarpool: updatedRoute,
            currentLocation: event.location,
            lastLocationUpdate: DateTime.now(),
            isNearDestination: isNear,
          ));
          break;

        case Failure():
          log('TAG: OnGoingCarpoolBloc - Error updating location: ${result.message}');
          // Actualizar solo la ubicación local sin el backend
          emit(state.copyWith(
            currentLocation: event.location,
            lastLocationUpdate: DateTime.now(),
            isNearDestination: isNear,
          ));
          break;

        case Loading():
        // Already updating
          break;
      }
    } catch (e) {
      log('TAG: OnGoingCarpoolBloc - Unexpected error updating location: $e');
    }
  }

  void _onOnGoingCarpoolErrorOccurred(OnGoingCarpoolErrorOccurred event, Emitter<OnGoingCarpoolState> emit) {
    log('TAG: OnGoingCarpoolBloc - Error occurred: ${event.message}');
    emit(state.copyWith(errorMessage: event.message));
  }

  Future<void> _onFinishCarpool(FinishCarpool event, Emitter<OnGoingCarpoolState> emit) async {
    log('TAG: OnGoingCarpoolBloc - Finishing carpool');

    emit(state.copyWith(isFinishingCarpool: true));

    add(const StopLocationTracking());

    try {
      await Future.delayed(const Duration(seconds: 1));

      _currentRouteId = null;

      emit(state.copyWith(
        isFinishingCarpool: false,
        successMessage: 'Carpool finalizado exitosamente',
      ));

      log('TAG: OnGoingCarpoolBloc - Carpool finished successfully');
    } catch (e) {
      log('TAG: OnGoingCarpoolBloc - Error finishing carpool: $e');
      emit(state.copyWith(
        isFinishingCarpool: false,
        errorMessage: 'Error al finalizar carpool: ${e.toString()}',
      ));
    }
  }

  String _formatDuration(int durationInMinutes) {
    if (durationInMinutes <= 0) return 'N/A';

    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes} min';
    }
  }

  String _formatDistance(double distanceInKm) {
    if (distanceInKm <= 0) return 'N/A';

    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toInt()} m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  double _calculateDistanceToDestination(Location currentLocation, Location destination) {
    return Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
  }

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    _locationUpdateTimer?.cancel();
    _positionStreamSubscription?.cancel();
    return super.close();
  }
}