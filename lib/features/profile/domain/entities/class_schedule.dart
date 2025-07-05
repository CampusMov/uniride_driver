import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'enum_day.dart';

class ClassSchedule extends Equatable {
  final String id;
  final String courseName;
  final String locationName;
  final double latitude;
  final double longitude;
  final String address;
  final TimeOfDay startedAt;
  final TimeOfDay endedAt;
  final EDay selectedDay;

  const ClassSchedule({
    this.id = '1',
    required this.courseName,
    required this.locationName,
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.address,
    required this.startedAt,
    required this.endedAt,
    required this.selectedDay,
  });

  String scheduleTime() {
    final startFormatted = '${startedAt.hour.toString().padLeft(2, '0')}:${startedAt.minute.toString().padLeft(2, '0')}';
    final endFormatted = '${endedAt.hour.toString().padLeft(2, '0')}:${endedAt.minute.toString().padLeft(2, '0')}';
    return '${selectedDay.showDay()} - $startFormatted a $endFormatted';
  }

  String timeRange() {
    final startFormatted = '${startedAt.hour.toString().padLeft(2, '0')}:${startedAt.minute.toString().padLeft(2, '0')}';
    final endFormatted = '${endedAt.hour.toString().padLeft(2, '0')}:${endedAt.minute.toString().padLeft(2, '0')}';
    return '$startFormatted - $endFormatted';
  }

  @override
  List<Object?> get props => [
    id,
    courseName,
    locationName,
    latitude,
    longitude,
    address,
    startedAt,
    endedAt,
    selectedDay,
  ];
}