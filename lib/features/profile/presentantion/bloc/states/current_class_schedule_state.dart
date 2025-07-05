import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniride_driver/features/profile/domain/entities/class_schedule.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/domain/entities/location.dart';
import '../../../domain/entities/enum_day.dart';

class CurrentClassScheduleState extends Equatable {
  final bool isEditing;
  final String? editingIndex;
  final String courseName;
  final Location? selectedLocation;
  final TimeOfDay? startedAt;
  final TimeOfDay? endedAt;
  final EDay? selectedDay;

  const CurrentClassScheduleState({
    this.isEditing = false,
    this.editingIndex,
    this.courseName = '',
    this.selectedLocation,
    this.startedAt,
    this.endedAt,
    this.selectedDay,
  });

  ClassSchedule toDomain() {
    final loc = selectedLocation!;
    return ClassSchedule(
      id: editingIndex ?? const Uuid().v4(),
      courseName: courseName,
      locationName: loc.name,
      latitude: loc.latitude,
      longitude: loc.longitude,
      address: loc.address,
      startedAt: startedAt!,
      endedAt: endedAt!,
      selectedDay: selectedDay!,
    );
  }

  CurrentClassScheduleState copyWith({
    bool? isEditing,
    String? editingIndex,
    String? courseName,
    Location? selectedLocation,
    TimeOfDay? startedAt,
    TimeOfDay? endedAt,
    EDay? selectedDay,
  }) {
    return CurrentClassScheduleState(
      isEditing: isEditing ?? this.isEditing,
      editingIndex: editingIndex ?? this.editingIndex,
      courseName: courseName ?? this.courseName,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }

  @override
  List<Object?> get props => [
    isEditing,
    editingIndex,
    courseName,
    selectedLocation,
    startedAt,
    endedAt,
    selectedDay,
  ];
}