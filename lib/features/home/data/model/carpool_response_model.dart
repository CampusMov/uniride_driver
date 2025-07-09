import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/home/domain/entities/enum_carpool_status.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

class CarpoolResponseModel {
  final String id;
  final String driverId;
  final String vehicleId;
  final String status;
  final int availableSeats;
  final int maxPassengers;
  final String scheduleId;
  final int radius;
  final String originName;
  final String originAddress;
  final double originLongitude;
  final double originLatitude;
  final String destinationName;
  final String destinationAddress;
  final double destinationLongitude;
  final double destinationLatitude;
  final String startedClassTime;
  final String endedClassTime;
  final String classDay;
  final bool isVisible;

  const CarpoolResponseModel({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.status,
    required this.availableSeats,
    required this.maxPassengers,
    required this.scheduleId,
    required this.radius,
    required this.originName,
    required this.originAddress,
    required this.originLongitude,
    required this.originLatitude,
    required this.destinationName,
    required this.destinationAddress,
    required this.destinationLongitude,
    required this.destinationLatitude,
    required this.startedClassTime,
    required this.endedClassTime,
    required this.classDay,
    required this.isVisible,
  });

  factory CarpoolResponseModel.fromJson(Map<String, dynamic> json) {
    return CarpoolResponseModel(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      status: json['status'] ?? '',
      availableSeats: json['availableSeats'] ?? 0,
      maxPassengers: json['maxPassengers'] ?? 0,
      scheduleId: json['scheduleId'] ?? '',
      radius: json['radius'] ?? 0,
      originName: json['originName'] ?? '',
      originAddress: json['originAddress'] ?? '',
      originLongitude: (json['originLongitude'] ?? 0.0).toDouble(),
      originLatitude: (json['originLatitude'] ?? 0.0).toDouble(),
      destinationName: json['destinationName'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
      destinationLongitude: (json['destinationLongitude'] ?? 0.0).toDouble(),
      destinationLatitude: (json['destinationLatitude'] ?? 0.0).toDouble(),
      startedClassTime: json['startedClassTime'] ?? '',
      endedClassTime: json['endedClassTime'] ?? '',
      classDay: json['classDay'] ?? '',
      isVisible: json['isVisible'] ?? true,
    );
  }

  Carpool toDomain() {
    return Carpool(
      id: id,
      driverId: driverId,
      vehicleId: vehicleId,
      status: CarpoolStatus.fromString(status),
      availableSeats: availableSeats,
      maxPassengers: maxPassengers,
      scheduleId: scheduleId,
      radius: radius,
      origin: Location(
          name: originName,
          latitude: originLatitude,
          longitude: originLongitude,
          address: originAddress
      ),
      destination: Location(
        name: destinationName,
        latitude: destinationLatitude,
        longitude: destinationLongitude,
        address: destinationAddress,
      ),
      startedClassTime: _parseTimeOfDay(startedClassTime),
      endedClassTime: _parseTimeOfDay(endedClassTime),
      classDay: classDay,
      isVisible: isVisible,
    );
  }

  TimeOfDay _parseTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return const TimeOfDay(hour: 0, minute: 0);
    }

    try {
      final parts = timeString.split(':');

      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }

      log('TAG - CarpoolResponseModel: ⚠️ Invalid time format: $timeString');
      return const TimeOfDay(hour: 0, minute: 0);

    } catch (e) {
      log('TAG - CarpoolResponseModel: ⚠️ Error parsing time: $e');
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}