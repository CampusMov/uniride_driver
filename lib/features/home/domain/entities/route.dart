import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/home/domain/entities/intersection.dart';

class Route extends Equatable {
  final List<Intersection> intersections;
  final double totalDistance;
  final double totalDuration;

  const Route({
    this.intersections = const [],
    this.totalDistance = 0.0,
    this.totalDuration = 0.0,
  });

  @override
  List<Object?> get props => [intersections, totalDistance, totalDuration];
}