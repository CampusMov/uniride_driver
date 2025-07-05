import 'package:flutter/material.dart';

import '../../domain/entities/class_schedule.dart';

class ClassScheduleRequestModel {
  final String? id;
  final String? courseName;
  final String? locationName;
  final double latitude;
  final double longitude;
  final String address;
  final String startedAt;
  final String endedAt;
  final String selectedDay;

  const ClassScheduleRequestModel({
    this.id,
    this.courseName,
    this.locationName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.startedAt,
    required this.endedAt,
    required this.selectedDay,
  });

  factory ClassScheduleRequestModel.fromDomain(ClassSchedule classSchedule) {
    return ClassScheduleRequestModel(
      id: classSchedule.id,
      courseName: classSchedule.courseName,
      locationName: classSchedule.locationName,
      latitude: classSchedule.latitude,
      longitude: classSchedule.longitude,
      address: classSchedule.address,
      startedAt: _timeOfDayToIsoString(classSchedule.startedAt),
      endedAt: _timeOfDayToIsoString(classSchedule.endedAt),
      selectedDay: classSchedule.selectedDay.value,
    );
  }

  static String _timeOfDayToIsoString(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return dateTime.toIso8601String();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'selectedDay': selectedDay,
    };
  }
}