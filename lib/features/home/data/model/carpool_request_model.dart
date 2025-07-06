import 'package:flutter/material.dart';
import 'package:uniride_driver/features/home/data/model/location_request_model.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';

class CarpoolRequestModel {
  final String driverId;
  final String vehicleId;
  final int maxPassengers;
  final String scheduleId;
  final int radius;
  final LocationRequestModel origin;
  final LocationRequestModel destination;
  final String startedClassTime;
  final String endedClassTime;
  final String classDay;

  const CarpoolRequestModel({
    required this.driverId,
    required this.vehicleId,
    required this.maxPassengers,
    required this.scheduleId,
    required this.radius,
    required this.origin,
    required this.destination,
    required this.startedClassTime,
    required this.endedClassTime,
    required this.classDay,
  });

  factory CarpoolRequestModel.fromDomain(Carpool entity) {
    return CarpoolRequestModel(
      driverId: entity.driverId,
      vehicleId: entity.vehicleId,
      maxPassengers: entity.maxPassengers,
      scheduleId: entity.scheduleId,
      radius: entity.radius,
      origin: LocationRequestModel.fromDomain(entity.origin),
      destination: LocationRequestModel.fromDomain(entity.destination),
      startedClassTime: _timeOfDayToString(entity.startedClassTime),
      endedClassTime: _timeOfDayToString(entity.endedClassTime),
      classDay: entity.classDay,
    );
  }

  static String _timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'vehicleId': vehicleId,
      'maxPassengers': maxPassengers,
      'scheduleId': scheduleId,
      'radius': radius,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'startedClassTime': startedClassTime,
      'endedClassTime': endedClassTime,
      'classDay': classDay,
    };
  }
}