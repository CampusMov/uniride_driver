import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;

  MapBloc() : super(MapState.initial) {
    on<MapInitialized>(_onMapInitialized);
    on<GetUserLocation>(_onGetUserLocation);
    on<CenterMap>(_onCenterMap);
    on<AddMarker>(_onAddMarker);
    on<AddMarkers>(_onAddMarkers);
    on<RemoveMarker>(_onRemoveMarker);
    on<ClearMarkers>(_onClearMarkers);
    on<CreatePolyline>(_onCreatePolyline);
    on<RemovePolyline>(_onRemovePolyline);
    on<ClearPolylines>(_onClearPolylines);
    on<FitMarkersToMap>(_onFitMarkersToMap);
    on<StartNavigation>(_onStartNavigation);
    on<StopNavigation>(_onStopNavigation);
    on<UpdateUserLocation>(_onUpdateUserLocation);
    on<ChangeMapType>(_onChangeMapType);
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    _locationUpdateTimer?.cancel();
    return super.close();
  }

  Future<void> _onMapInitialized(MapInitialized event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      controller: event.controller,
      isLoading: false,
    ));

    add(GetUserLocation());
  }

  Future<void> _onGetUserLocation(GetUserLocation event, Emitter<MapState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final permission = await _checkLocationPermission();
      if (!permission) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Permisos de ubicación denegados',
        ));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final userLocation = LatLng(position.latitude, position.longitude);

      emit(state.copyWith(
        isLoading: false,
        userLocation: userLocation,
        currentCenter: userLocation,
        locationPermissionGranted: true,
        error: null,
      ));

      add(CenterMap(userLocation));

      _startLocationTracking();

    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error al obtener ubicación: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCenterMap(CenterMap event, Emitter<MapState> emit) async {
    if (state.controller == null) return;

    try {
      await state.controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: event.location,
            zoom: event.zoom,
          ),
        ),
      );

      emit(state.copyWith(
        currentCenter: event.location,
        currentZoom: event.zoom,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Error al centrar mapa: ${e.toString()}'));
    }
  }

  Future<void> _onAddMarker(AddMarker event, Emitter<MapState> emit) async {
    final newMarker = Marker(
      markerId: MarkerId(event.markerId),
      position: event.position,
      infoWindow: InfoWindow(
        title: event.title,
        snippet: event.snippet,
      ),
      icon: event.icon ?? BitmapDescriptor.defaultMarker,
      onTap: event.onTap,
    );

    final updatedMarkers = Set<Marker>.from(state.markers);
    updatedMarkers.add(newMarker);

    emit(state.copyWith(markers: updatedMarkers));
  }

  Future<void> _onAddMarkers(AddMarkers event, Emitter<MapState> emit) async {
    final updatedMarkers = Set<Marker>.from(state.markers);

    for (final markerData in event.markers) {
      final marker = Marker(
        markerId: MarkerId(markerData.id),
        position: markerData.position,
        infoWindow: InfoWindow(
          title: markerData.title,
          snippet: markerData.snippet,
        ),
        icon: markerData.icon ?? BitmapDescriptor.defaultMarker,
        onTap: markerData.onTap,
      );
      updatedMarkers.add(marker);
    }

    emit(state.copyWith(markers: updatedMarkers));
  }

  void _onRemoveMarker(RemoveMarker event, Emitter<MapState> emit) {
    final updatedMarkers = Set<Marker>.from(state.markers);
    updatedMarkers.removeWhere((marker) => marker.markerId.value == event.markerId);

    emit(state.copyWith(markers: updatedMarkers));
  }

  void _onClearMarkers(ClearMarkers event, Emitter<MapState> emit) {
    emit(state.copyWith(markers: const {}));
  }

  Future<void> _onCreatePolyline(CreatePolyline event, Emitter<MapState> emit) async {
    final polyline = Polyline(
      polylineId: PolylineId(event.polylineId),
      points: event.points,
      color: event.color,
      width: event.width.toInt(),
      patterns: event.patterns ?? [],
    );

    final updatedPolylines = Set<Polyline>.from(state.polylines);
    updatedPolylines.add(polyline);

    emit(state.copyWith(polylines: updatedPolylines));

    // Ajustar el mapa para mostrar toda la polyline
    if (event.points.isNotEmpty) {
      _fitPointsToMap(event.points, emit);
    }
  }

  void _onRemovePolyline(RemovePolyline event, Emitter<MapState> emit) {
    final updatedPolylines = Set<Polyline>.from(state.polylines);
    updatedPolylines.removeWhere((polyline) => polyline.polylineId.value == event.polylineId);

    emit(state.copyWith(polylines: updatedPolylines));
  }

  void _onClearPolylines(ClearPolylines event, Emitter<MapState> emit) {
    emit(state.copyWith(polylines: const {}));
  }

  Future<void> _onFitMarkersToMap(FitMarkersToMap event, Emitter<MapState> emit) async {
    if (state.controller == null || state.markers.isEmpty) return;

    final bounds = state.markersBounds;
    if (bounds == null) return;

    try {
      await state.controller!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, event.padding.left),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Error al ajustar mapa: ${e.toString()}'));
    }
  }

  Future<void> _onStartNavigation(StartNavigation event, Emitter<MapState> emit) async {
    try {
      final route = [event.origin];
      if (event.waypoints != null) {
        route.addAll(event.waypoints!);
      }
      route.add(event.destination);

      add(CreatePolyline(
        polylineId: 'navigation_route',
        points: route,
        color: const Color(0xFF2196F3),
        width: 6.0,
      ));

      add(AddMarker(
        markerId: 'origin',
        position: event.origin,
        title: 'Origen',
        icon: await _createCustomMarker('🚗', Colors.green),
      ));

      add(AddMarker(
        markerId: 'destination',
        position: event.destination,
        title: 'Destino',
        icon: await _createCustomMarker('🏁', Colors.red),
      ));

      emit(state.copyWith(
        isNavigating: true,
        currentRoute: route,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Error al iniciar navegación: ${e.toString()}'));
    }
  }

  void _onStopNavigation(StopNavigation event, Emitter<MapState> emit) {
    // Limpiar ruta
    add(const RemovePolyline('navigation_route'));

    // Remover markers de navegación
    add(const RemoveMarker('origin'));
    add(const RemoveMarker('destination'));

    emit(state.copyWith(
      isNavigating: false,
      currentRoute: const [],
    ));
  }

  void _onUpdateUserLocation(UpdateUserLocation event, Emitter<MapState> emit,) {
    emit(state.copyWith(
      userLocation: event.location,
      userHeading: event.heading,
    ));

    // Si estamos navegando, actualizar el marker del usuario
    if (state.isNavigating) {
      add(AddMarker(
        markerId: 'user_location',
        position: event.location,
        title: 'Tu ubicación',
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }
  }

  void _onChangeMapType(ChangeMapType event, Emitter<MapState> emit) {
    emit(state.copyWith(mapType: event.mapType));
  }

  Future<bool> _checkLocationPermission() async {
    final permission = await Permission.location.request();
    return permission == PermissionStatus.granted;
  }

  void _startLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      add(UpdateUserLocation(
        LatLng(position.latitude, position.longitude),
        heading: position.heading,
      ));
    });
  }

  Future<void> _fitPointsToMap(List<LatLng> points, Emitter<MapState> emit) async {
    if (state.controller == null || points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await state.controller!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Error al ajustar vista: ${e.toString()}'));
    }
  }

  Future<BitmapDescriptor> _createCustomMarker(String text, Color color) async {
    return BitmapDescriptor.defaultMarkerWithHue(
      color == Colors.green ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
    );
  }
}