import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/home/domain/entities/route.dart';
import 'package:uniride_driver/features/home/domain/entities/way_point.dart';
import 'package:uniride_driver/features/home/domain/repositories/way_point_repository.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

import '../../../../../core/events/app_event_bus.dart';
import '../../../../../core/events/app_events.dart';
import '../../../../../core/utils/resource.dart';
import '../../../domain/entities/route_carpool.dart';
import '../../../domain/entities/routing-matching/enum_trip_state.dart';
import '../../../domain/repositories/carpool_repository.dart';
import '../../../domain/repositories/route_carpool_repository.dart';
import '../../../domain/repositories/route_repository.dart';
import 'waiting_carpool_event.dart';
import 'waiting_carpool_state.dart';

class WaitingCarpoolBloc extends Bloc<WaitingCarpoolEvent, WaitingCarpoolState> {
  final CarpoolRepository carpoolRepository;
  final RouteRepository routeRepository;
  final RouteCarpoolRepository routeCarpoolRepository;
  final WayPointRepository wayPointRepository;
  late StreamSubscription _eventBusSubscription;

  WaitingCarpoolBloc({
    required this.carpoolRepository,
    required this.routeRepository,
    required this.routeCarpoolRepository,
    required this.wayPointRepository,
  }) : super(const WaitingCarpoolState()) {
    on<LoadCarpool>(_onLoadCarpool);
    on<LoadRouteCarpool>(_onLoadRouteCarpool);
    on<LoadWaypoints>(_onLoadWayPoints);
    on<GenerateRoute>(_onGenerateRoute);
    on<StartCarpool>(_onStartCarpool);
    on<CancelCarpool>(_onCancelCarpool);
    on<RefreshCarpoolData>(_onRefreshCarpoolData);
    on<GetUserLocation>(_onGetUserLocation);

    add(GetUserLocation());

    _eventBusSubscription = AppEventBus().on<CarpoolCreatedSuccessfully>().listen((event) {
      add(LoadCarpool(event.carpoolId));
    });

    _eventBusSubscription = AppEventBus().on<PassengerRequestAccepted>().listen((event) {
      log('TAG: WaitingCarpoolBloc - Load all waypoints');
      add(const LoadWaypoints());
    });
  }

  void _onLoadCarpool(LoadCarpool event, Emitter<WaitingCarpoolState> emit) async {
    emit(state.copyWith(isLoadingCarpool: true, errorMessage: null));

    try {
      log('TAG: WaitingCarpoolBloc - Loading carpool with ID: ${event.carpoolId}');

      final result = await carpoolRepository.getCarpoolById(event.carpoolId);

      switch (result) {
        case Success<Carpool>():
          final carpool = result.data;
          log('TAG: WaitingCarpoolBloc - Carpool loaded successfully: ${carpool.id}');

          emit(state.copyWith(
            isLoadingCarpool: false,
            carpool: carpool,
            successMessage: 'Carpool cargado exitosamente',
          ));

          // Automatically load route carpool after loading carpool
          add(const LoadRouteCarpool());

          // Automatically generate route after loading carpool
          add(const GenerateRoute());
          break;

        case Failure<Carpool>():
          log('TAG: WaitingCarpoolBloc - Failed to load carpool: ${result.message}');
          emit(state.copyWith(
            isLoadingCarpool: false,
            errorMessage: 'Error al cargar carpool: ${result.message}',
          ));
          break;

        case Loading<dynamic>():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error loading carpool: $e');
      emit(state.copyWith(
        isLoadingCarpool: false,
        errorMessage: 'Error inesperado al cargar carpool: ${e.toString()}',
      ));
    }
  }

  void _onGenerateRoute(GenerateRoute event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool cargado para generar ruta'));
      return;
    }

    emit(state.copyWith(isLoadingRoute: true, errorMessage: null));

    try {
      final carpool = state.carpool!;

      log('TAG: WaitingCarpoolBloc - Generating route from (${carpool.origin.latitude}, ${carpool.origin.longitude}) to (${carpool.destination.latitude}, ${carpool.destination.longitude})');

      final result = await routeRepository.getRoute(
        carpool.origin.latitude,
        carpool.origin.longitude,
        carpool.destination.latitude,
        carpool.destination.longitude,
      );

      switch (result) {
        case Success<Route>():
          final route = result.data;
          final coordinates = route.intersections.map((intersection) => intersection.toLatLng()).toList();

          log('TAG: WaitingCarpoolBloc - Route generated successfully with ${coordinates.length} points');

          emit(state.copyWith(
            isLoadingRoute: false,
            route: route,
            routeCoordinates: coordinates,
            successMessage: 'Ruta generada exitosamente',
          ));

          AppEventBus().emit(AddPolylineRequested(
            coordinates: coordinates,
            polylineId: 'carpool_route',
            color: const Color(0xFF2196F3),
            width: 5,
          ));

          log('TAG: WaitingCarpoolBloc - Polyline sent to MapBloc');
          break;

        case Failure<Route>():
          log('TAG: WaitingCarpoolBloc - Failed to generate route: ${result.message}');
          emit(state.copyWith(
            isLoadingRoute: false,
            errorMessage: 'Error al generar ruta: ${result.message}',
          ));
          break;

        case Loading<dynamic>():
        // Already loading
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error generating route: $e');
      emit(state.copyWith(
        isLoadingRoute: false,
        errorMessage: 'Error inesperado al generar ruta: ${e.toString()}',
      ));
    }
  }

  void _onLoadRouteCarpool(LoadRouteCarpool event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool cargado para obtener ruta'));
      return;
    }

    try {
      log('TAG: WaitingCarpoolBloc - Loading route carpool with carpool ID: ${state.carpool!.id}');

      final result = await routeCarpoolRepository.getRouteByCarpoolId(state.carpool!.id);
      switch (result) {
        case Success<RouteCarpool>():
          final routeCarpool = result.data;
          log('TAG: WaitingCarpoolBloc - Route carpool loaded successfully: $routeCarpool');

          emit(state.copyWith(
            routeCarpool: routeCarpool,
            successMessage: 'Ruta de carpool cargada exitosamente',
          ));

          // Automatically load waypoints after loading route carpool
          add(const LoadWaypoints());

          break;

        case Failure<RouteCarpool>():
          log('TAG: WaitingCarpoolBloc - Failed to load route carpool: ${result.message}');

          emit(state.copyWith(
            routeCarpool: null,
            errorMessage: 'Error al cargar ruta de carpool: ${result.message}',
          ));
          break;

        case Loading<dynamic>():
          log('TAG: WaitingCarpoolBloc - Already loading route carpool');
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error loading route carpool: $e');
      emit(state.copyWith(
        errorMessage: 'Error inesperado al cargar ruta de carpool: ${e.toString()}',
      ));
    }
  }

  void _onLoadWayPoints(LoadWaypoints event, Emitter<WaitingCarpoolState> emit) async {
    if (state.routeCarpool == null) {
      emit(state.copyWith(errorMessage: 'No hay ruta de carpool cargada para obtener waypoints'));
      return;
    }

    try {
      log('TAG: WaitingCarpoolBloc - Loading waypoints for route carpool ID: ${state.routeCarpool!.id}');

      final result = await wayPointRepository.getWayPointsByRouteId(state.routeCarpool!.id);
      switch (result) {
        case Success<List<WayPoint>>():
          final waypoints = result.data;
          log('TAG: WaitingCarpoolBloc - Waypoints loaded successfully: ${waypoints.length} waypoints');

          final updatedRouteCarpool = state.routeCarpool!.setWayPoints(waypoints);

          emit(state.copyWith(
            routeCarpool: updatedRouteCarpool,
            successMessage: 'Waypoints cargados exitosamente',
          ));

          // Emit event to update route carpool with new waypoints
          AppEventBus().emit(WaypointsUpdated(state.routeCarpool!.wayPoints));

          break;

        case Failure<List<WayPoint>>():
          log('TAG: WaitingCarpoolBloc - Failed to load waypoints: ${result.message}');
          emit(state.copyWith(
            errorMessage: 'Error al cargar waypoints: ${result.message}',
          ));
          break;

        case Loading<List<WayPoint>>():
          log('TAG: WaitingCarpoolBloc - Already loading waypoints');
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error loading waypoints: $e');
      emit(state.copyWith(
        errorMessage: 'Error inesperado al cargar waypoints: ${e.toString()}',
      ));
    }
  }

  void _onStartCarpool(StartCarpool event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool para iniciar'));
      return;
    }

    if (state.userLocation == null) {
      emit(state.copyWith(errorMessage: 'Ubicación del usuario no disponible'));
      return;
    }

    emit(state.copyWith(isStartingCarpool: true, errorMessage: null));

    try {
      log('TAG: WaitingCarpoolBloc - Starting carpool: ${state.carpool!.id}');

      final result = await carpoolRepository.startCarpool(
        state.carpool!.id,
        Location(
          latitude: state.userLocation!.latitude,
          longitude: state.userLocation!.longitude,
        ),
      );

      switch (result) {
        case Success<Carpool>():
          final startedCarpool = result.data;
          log('TAG: WaitingCarpoolBloc - Carpool started successfully: ${startedCarpool.id}');

          emit(state.copyWith(
            isStartingCarpool: false,
            carpool: startedCarpool,
            successMessage: 'Carpool iniciado exitosamente',
          ));

          // Emit event to change trip state to ongoing
          AppEventBus().emit(const TripStateChangeRequested(TripState.ongoingCarpool));

          // Emit event to notify that carpool has started
          AppEventBus().emit(CarpoolStartedSuccessfully(startedCarpool.id));
          break;

        case Failure<Carpool>():
          log('TAG: WaitingCarpoolBloc - Failed to start carpool: ${result.message}');
          emit(state.copyWith(
            isStartingCarpool: false,
            errorMessage: 'Error al iniciar carpool: ${result.message}',
          ));
          break;

        case Loading<Carpool>():
          log('TAG: WaitingCarpoolBloc - Already starting carpool');
          break;
      }
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error starting carpool: $e');
      emit(state.copyWith(
        isStartingCarpool: false,
        errorMessage: 'Error al iniciar carpool: ${e.toString()}',
      ));
    }
  }

  void _onCancelCarpool(CancelCarpool event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool == null) {
      emit(state.copyWith(errorMessage: 'No hay carpool para cancelar'));
      return;
    }

    emit(state.copyWith(isCancellingCarpool: true, errorMessage: null));

    try {
      // TODO: Implement cancel carpool logic
      // This might involve updating carpool status to CANCELLED

      log('TAG: WaitingCarpoolBloc - Cancelling carpool: ${state.carpool!.id}');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Clear polyline from map via EventBus
      AppEventBus().emit(const RemovePolylineRequested('carpool_route'));

      emit(state.copyWith(
        isCancellingCarpool: false,
        successMessage: 'Carpool cancelado exitosamente',
      ));

      // Emit event to change trip state back to creating
      AppEventBus().emit(const TripStateChangeRequested(TripState.creatingCarpool));

      log('TAG: WaitingCarpoolBloc - Carpool cancelled successfully');
    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error cancelling carpool: $e');
      emit(state.copyWith(
        isCancellingCarpool: false,
        errorMessage: 'Error al cancelar carpool: ${e.toString()}',
      ));
    }
  }

  void _onRefreshCarpoolData(RefreshCarpoolData event, Emitter<WaitingCarpoolState> emit) async {
    if (state.carpool != null) {
      add(LoadCarpool(state.carpool!.id));
    }
  }

  Future<void> _onGetUserLocation(GetUserLocation event, Emitter<WaitingCarpoolState> emit) async {
    try {
      log('TAG: WaitingCarpoolBloc - Getting user location');

      final permission = await _checkLocationPermission();

      if (!permission) {
        emit(state.copyWith(errorMessage: 'Permiso de ubicación denegado'));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final userLocation = LatLng(position.latitude, position.longitude);

      log('TAG: WaitingCarpoolBloc - User location obtained: $userLocation');

      emit(state.copyWith(
        userLocation: userLocation,
      ));

    } catch (e) {
      log('TAG: WaitingCarpoolBloc - Error getting user location: $e');
      emit(state.copyWith(errorMessage: 'Error al obtener ubicación del usuario: ${e.toString()}'));
    }
  }

  Future<bool> _checkLocationPermission() async {
    final permission = await Permission.location.request();
    return permission == PermissionStatus.granted;
  }

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    return super.close();
  }
}