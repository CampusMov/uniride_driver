import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

class WayPoint extends Equatable {
  final String id;
  final String passengerId;
  final Location location;
  final DateTime? estimatedArrivalTime;
  final DateTime? realArrivalTime;

  const WayPoint({
    this.id = '1',
    required this.passengerId,
    required this.location,
    this.estimatedArrivalTime,
    this.realArrivalTime,
  });

  @override
  List<Object?> get props => [
    id,
    passengerId,
    location,
    estimatedArrivalTime,
    realArrivalTime,
  ];
}