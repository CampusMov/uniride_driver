import 'package:flutter/material.dart';

import '../../domain/entities/class_schedule.dart';
import '../../domain/entities/enum_day.dart';

class ClassScheduleResponseModel {
  final String? id;
  final String? courseName;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? startedAt;
  final String? endedAt;
  final String? selectedDay;

  const ClassScheduleResponseModel({
    this.id,
    this.courseName,
    this.locationName,
    this.latitude,
    this.longitude,
    this.address,
    this.startedAt,
    this.endedAt,
    this.selectedDay,
  });

  factory ClassScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassScheduleResponseModel(
      id: json['id'],
      courseName: json['courseName'],
      locationName: json['locationName'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      address: json['address'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      selectedDay: json['selectedDay'],
    );
  }

  ClassSchedule toDomain() {
    return ClassSchedule(
      id: id ?? '',
      courseName: courseName ?? '',
      locationName: locationName ?? '',
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      address: address ?? '',
      startedAt: _parseTimeOfDay(startedAt),
      endedAt: _parseTimeOfDay(endedAt),
      selectedDay: EDay.fromString(selectedDay),
    );
  }

  TimeOfDay _parseTimeOfDay(String? timeString) {
    if (timeString == null) return const TimeOfDay(hour: 0, minute: 0);
    try {
      final dateTime = DateTime.parse(timeString);
      return TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}