import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../shared/domain/entities/location.dart';
import 'enum_carpool_status.dart';

class Carpool extends Equatable {
  final String id;
  final String driverId;
  final String vehicleId;
  final CarpoolStatus status;
  final int? availableSeats;
  final int maxPassengers;
  final String scheduleId;
  final int radius;
  final Location origin;
  final Location destination;
  final TimeOfDay startedClassTime;
  final TimeOfDay endedClassTime;
  final String classDay;
  final bool isVisible;

  const Carpool({
    this.id = '1',
    required this.driverId,
    required this.vehicleId,
    this.status = CarpoolStatus.created,
    this.availableSeats,
    required this.maxPassengers,
    required this.scheduleId,
    required this.radius,
    required this.origin,
    required this.destination,
    required this.startedClassTime,
    required this.endedClassTime,
    required this.classDay,
    this.isVisible = true,
  });

  @override
  List<Object?> get props => [
    id,
    driverId,
    vehicleId,
    status,
    availableSeats,
    maxPassengers,
    scheduleId,
    radius,
    origin,
    destination,
    startedClassTime,
    endedClassTime,
    classDay,
    isVisible,
  ];
}