import 'package:flutter/material.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/profile/domain/entities/class_schedule.dart';
import 'package:uniride_driver/features/profile/domain/entities/vehicle.dart';

import '../../../../shared/domain/entities/location.dart';
import '../../../domain/entities/place_prediction.dart';

class CreateCarpoolState extends Equatable {
  final User? user;
  final Vehicle? vehicle;
  final int maxPassengers;
  final ClassSchedule? classSchedule;
  final int radius;
  final Location? originLocation;
  final bool isLoading;
  final List<Prediction> locationPredictions;
  final bool isSelectOriginLocationDialogOpen;
  final bool isSelectClassScheduleDialogOpen;

  // Class Schedule Dialog Properties
  final List<ClassSchedule> allClassSchedules;
  final List<ClassSchedule> filteredClassSchedules;
  final String classScheduleSearchQuery;
  final bool isLoadingClassSchedules;

  const CreateCarpoolState({
    this.user,
    this.vehicle,
    this.maxPassengers = 4,
    this.classSchedule,
    this.radius = 100,
    this.originLocation,
    this.isLoading = false,
    this.locationPredictions = const [],
    this.isSelectOriginLocationDialogOpen = false,
    this.isSelectClassScheduleDialogOpen = false,
    this.allClassSchedules = const [],
    this.filteredClassSchedules = const [],
    this.classScheduleSearchQuery = '',
    this.isLoadingClassSchedules = false,
  });

  Carpool toDomain() {
    return Carpool(
      driverId: user?.id ?? '',
      vehicleId: vehicle?.id ?? '',
      maxPassengers: maxPassengers,
      scheduleId: classSchedule?.id ?? '',
      radius: radius,
      origin: originLocation ?? Location(),
      destination: Location(
        name: classSchedule?.locationName ?? '',
        latitude: classSchedule?.latitude ?? 0.0,
        longitude: classSchedule?.longitude ?? 0.0,
        address: classSchedule?.address ?? '',
      ),
      classDay: classSchedule?.selectedDay.value ?? '',
      startedClassTime: classSchedule?.startedAt ?? TimeOfDay.now(),
      endedClassTime: classSchedule?.endedAt ?? TimeOfDay.now(),
    );
  }

  bool get isValidCarpool =>
      user!= null &&
          user?.id != '' &&
          vehicle != null &&
          vehicle?.id != '' &&
          isValidMaxPassengers &&
          classSchedule != null &&
          isValidRadius &&
          originLocation != null;

  bool get isValidMaxPassengers =>
      maxPassengers > 0 &&
          maxPassengers <= 4;

  bool get isValidRadius =>
      radius > 0 &&
          radius <= 100;

  CreateCarpoolState copyWith({
    User? user,
    Vehicle? vehicle,
    int? maxPassengers,
    ClassSchedule? classSchedule,
    int? radius,
    Location? originLocation,
    bool? isLoading,
    List<Prediction>? locationPredictions,
    bool? isSelectOriginLocationDialogOpen,
    bool? isSelectClassScheduleDialogOpen,
    List<ClassSchedule>? allClassSchedules,
    List<ClassSchedule>? filteredClassSchedules,
    String? classScheduleSearchQuery,
    bool? isLoadingClassSchedules,
  }) {
    return CreateCarpoolState(
      user: user ?? this.user,
      vehicle: vehicle ?? this.vehicle,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      classSchedule: classSchedule ?? this.classSchedule,
      radius: radius ?? this.radius,
      originLocation: originLocation ?? this.originLocation,
      isLoading: isLoading ?? this.isLoading,
      locationPredictions: locationPredictions ?? this.locationPredictions,
      isSelectOriginLocationDialogOpen: isSelectOriginLocationDialogOpen ?? this.isSelectOriginLocationDialogOpen,
      isSelectClassScheduleDialogOpen: isSelectClassScheduleDialogOpen ?? this.isSelectClassScheduleDialogOpen,
      allClassSchedules: allClassSchedules ?? this.allClassSchedules,
      filteredClassSchedules: filteredClassSchedules ?? this.filteredClassSchedules,
      classScheduleSearchQuery: classScheduleSearchQuery ?? this.classScheduleSearchQuery,
      isLoadingClassSchedules: isLoadingClassSchedules ?? this.isLoadingClassSchedules,
    );
  }

  @override
  List<Object?> get props => [
    user,
    vehicle,
    maxPassengers,
    classSchedule,
    radius,
    originLocation,
    isLoading,
    locationPredictions,
    isSelectOriginLocationDialogOpen,
    isSelectClassScheduleDialogOpen,
    allClassSchedules,
    filteredClassSchedules,
    classScheduleSearchQuery,
    isLoadingClassSchedules,
  ];
}