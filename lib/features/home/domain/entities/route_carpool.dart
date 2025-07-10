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