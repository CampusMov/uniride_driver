import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/home/domain/entities/way_point.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

class RouteCarpool extends Equatable {
  final String id;
  final String carpoolId;
  final DateTime? realStartedTime;
  final DateTime? estimatedEndedTime;
  final double? estimatedDurationMinutes;
  final double? estimatedDistanceKm;
  final Location origin;
  final Location destination;
  final Location carpoolCurrentLocation;
  final List<WayPoint> wayPoints;

  const RouteCarpool({
    this.id = '1',
    required this.carpoolId,
    this.realStartedTime,
    this.estimatedEndedTime,
    this.estimatedDurationMinutes,
    this.estimatedDistanceKm,
    required this.origin,
    required this.destination,
    required this.carpoolCurrentLocation,
    this.wayPoints = const [],
  });
  RouteCarpool addWayPoint(WayPoint wayPoint) {
    log('TAG: RouteCarpool - Adding waypoint: ${wayPoint.id}');
    return copyWith(
      wayPoints: [...wayPoints, wayPoint],
    );
  }

  RouteCarpool clearWayPoints() {
    log('TAG: RouteCarpool - Clearing waypoints');
    return copyWith(
      wayPoints: const [],
    );
  }

  RouteCarpool setWayPoints(List<WayPoint> newWayPoints) {
    log('TAG: RouteCarpool - Setting ${newWayPoints.length} waypoints');
    return copyWith(
      wayPoints: List.unmodifiable(newWayPoints),
    );
  }

  RouteCarpool copyWith({
    String? id,
    String? carpoolId,
    DateTime? realStartedTime,
    DateTime? estimatedEndedTime,
    double? estimatedDurationMinutes,
    double? estimatedDistanceKm,
    Location? origin,
    Location? destination,
    Location? carpoolCurrentLocation,
    List<WayPoint>? wayPoints,
  }) {
    return RouteCarpool(
      id: id ?? this.id,
      carpoolId: carpoolId ?? this.carpoolId,
      realStartedTime: realStartedTime ?? this.realStartedTime,
      estimatedEndedTime: estimatedEndedTime ?? this.estimatedEndedTime,
      estimatedDurationMinutes: estimatedDurationMinutes ??
          this.estimatedDurationMinutes,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      carpoolCurrentLocation: carpoolCurrentLocation ??
          this.carpoolCurrentLocation,
      wayPoints: wayPoints ?? this.wayPoints,
    );
  }

  @override
  List<Object?> get props => [
    id,
    carpoolId,
    realStartedTime,
    estimatedEndedTime,
    estimatedDurationMinutes,
    estimatedDistanceKm,
    origin,
    destination,
    carpoolCurrentLocation,
    wayPoints,
  ];
}