import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/map/marker_data.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

// Init event for the map
class MapInitialized extends MapEvent {
  final GoogleMapController controller;

  const MapInitialized(this.controller);

  @override
  List<Object?> get props => [controller];
}

// Get user location
class GetUserLocation extends MapEvent {}

// Center the map to a specific location
class CenterMap extends MapEvent {
  final LatLng location;
  final double zoom;

  const CenterMap(this.location, {this.zoom = 15.0});

  @override
  List<Object?> get props => [location, zoom];
}

// Add a single marker
class AddMarker extends MapEvent {
  final String markerId;
  final LatLng position;
  final String title;
  final String snippet;
  final BitmapDescriptor? icon;
  final VoidCallback? onTap;

  const AddMarker({
    required this.markerId,
    required this.position,
    required this.title,
    this.snippet = '',
    this.icon,
    this.onTap,
  });

  @override
  List<Object?> get props => [markerId, position, title, snippet, icon];
}

// Add multiple markers
class AddMarkers extends MapEvent {
  final List<MarkerData> markers;

  const AddMarkers(this.markers);

  @override
  List<Object?> get props => [markers];
}

// Remove a single marker
class RemoveMarker extends MapEvent {
  final String markerId;

  const RemoveMarker(this.markerId);

  @override
  List<Object?> get props => [markerId];
}

// Remove multiple markers
class ClearMarkers extends MapEvent {}

// Create a polyline with given points
class CreatePolyline extends MapEvent {
  final String polylineId;
  final List<LatLng> points;
  final Color color;
  final double width;
  final List<PatternItem>? patterns;

  const CreatePolyline({
    required this.polylineId,
    required this.points,
    this.color = const Color(0xFF2196F3),
    this.width = 5.0,
    this.patterns,
  });

  @override
  List<Object?> get props => [polylineId, points, color, width, patterns];
}

// Remove a polyline by its ID
class RemovePolyline extends MapEvent {
  final String polylineId;

  const RemovePolyline(this.polylineId);

  @override
  List<Object?> get props => [polylineId];
}

// Clear all polylines from the map
class ClearPolylines extends MapEvent {}

// Fit all markers to the map view with optional padding
class FitMarkersToMap extends MapEvent {
  final EdgeInsets padding;

  const FitMarkersToMap({this.padding = const EdgeInsets.all(100.0)});

  @override
  List<Object?> get props => [padding];
}

// Start navigation from origin to destination with optional waypoints
class StartNavigation extends MapEvent {
  final LatLng origin;
  final LatLng destination;
  final List<LatLng>? waypoints;

  const StartNavigation({
    required this.origin,
    required this.destination,
    this.waypoints,
  });

  @override
  List<Object?> get props => [origin, destination, waypoints];
}

// Stop ongoing navigation
class StopNavigation extends MapEvent {}

// Update the user's current location on the map
class UpdateUserLocation extends MapEvent {
  final LatLng location;
  final double heading;

  const UpdateUserLocation(this.location, {this.heading = 0.0});

  @override
  List<Object?> get props => [location, heading];
}

// Change the map type (normal, satellite, terrain, hybrid)
class ChangeMapType extends MapEvent {
  final MapType mapType;

  const ChangeMapType(this.mapType);

  @override
  List<Object?> get props => [mapType];
}