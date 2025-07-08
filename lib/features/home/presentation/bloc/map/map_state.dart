import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/map/navigation_stats.dart';

class MapState extends Equatable {
  final bool isLoading;
  final String? error;
  final GoogleMapController? controller;
  final LatLng? userLocation;
  final LatLng? currentCenter;
  final double currentZoom;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final MapType mapType;
  final bool isNavigating;
  final List<LatLng> currentRoute;
  final bool locationPermissionGranted;
  final bool isTrackingUser;
  final double userHeading;
  const MapState({
    this.isLoading = false,
    this.error,
    this.controller,
    this.userLocation,
    this.currentCenter,
    this.currentZoom = 15.0,
    this.markers = const {},
    this.polylines = const {},
    this.circles = const {},
    this.mapType = MapType.normal,
    this.isNavigating = false,
    this.currentRoute = const [],
    this.locationPermissionGranted = false,
    this.isTrackingUser = false,
    this.userHeading = 0.0,
  });

  // Init state
  static const MapState initial = MapState();

  // Method to create a copy of the state with updated values
  MapState copyWith({
    bool? isLoading,
    String? error,
    GoogleMapController? controller,
    LatLng? userLocation,
    LatLng? currentCenter,
    double? currentZoom,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    MapType? mapType,
    bool? isNavigating,
    List<LatLng>? currentRoute,
    bool? locationPermissionGranted,
    bool? isTrackingUser,
    double? userHeading,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      controller: controller ?? this.controller,
      userLocation: userLocation ?? this.userLocation,
      currentCenter: currentCenter ?? this.currentCenter,
      currentZoom: currentZoom ?? this.currentZoom,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      circles: circles ?? this.circles,
      mapType: mapType ?? this.mapType,
      isNavigating: isNavigating ?? this.isNavigating,
      currentRoute: currentRoute ?? this.currentRoute,
      locationPermissionGranted: locationPermissionGranted ?? this.locationPermissionGranted,
      isTrackingUser: isTrackingUser ?? this.isTrackingUser,
      userHeading: userHeading ?? this.userHeading,
    );
  }
  // Getter to check if the map is loading
  bool get isMapReady => controller != null;

  // Getter to check if there is an error
  bool get hasMarkers => markers.isNotEmpty;

  // Getter to check if there are polylines
  bool get hasPolylines => polylines.isNotEmpty;

  // Getter to check if there are circles
  LatLng? get displayLocation => currentCenter ?? userLocation;

  // Getter to check if user location is available
  bool get canShowUserLocation =>
      locationPermissionGranted && userLocation != null;

  // Getter to get the bounds of all markers
  LatLngBounds? get markersBounds {
    if (markers.isEmpty) return null;

    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (final marker in markers) {
      minLat = minLat < marker.position.latitude ? minLat : marker.position.latitude;
      maxLat = maxLat > marker.position.latitude ? maxLat : marker.position.latitude;
      minLng = minLng < marker.position.longitude ? minLng : marker.position.longitude;
      maxLng = maxLng > marker.position.longitude ? maxLng : marker.position.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // Getter to check if navigation is active
  NavigationStats get navigationStats {
    if (!isNavigating || currentRoute.isEmpty) {
      return NavigationStats.empty;
    }

    double totalDistance = 0.0;
    for (int i = 0; i < currentRoute.length - 1; i++) {
      totalDistance += _calculateDistance(
        currentRoute[i],
        currentRoute[i + 1],
      );
    }

    return NavigationStats(
      totalDistance: totalDistance,
      waypoints: currentRoute.length,
      isActive: isNavigating,
    );
  }
  // Method to calculate the distance between two LatLng points
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000;

    double lat1Rad = point1.latitude * (3.141592653589793 / 180);
    double lat2Rad = point2.latitude * (3.141592653589793 / 180);
    double deltaLatRad = (point2.latitude - point1.latitude) * (3.141592653589793 / 180);
    double deltaLngRad = (point2.longitude - point1.longitude) * (3.141592653589793 / 180);

    double a = pow(sin(deltaLatRad / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) *
            pow(sin(deltaLngRad / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    controller,
    userLocation,
    currentCenter,
    currentZoom,
    markers,
    polylines,
    circles,
    mapType,
    isNavigating,
    currentRoute,
    locationPermissionGranted,
    isTrackingUser,
    userHeading,
  ];
}