import 'package:equatable/equatable.dart';

import 'enum_vehicle_status.dart';

class Vehicle extends Equatable {
  final String id;
  final String brand;
  final String model;
  final int year;
  final EVehicleStatus status;
  final String vin;
  final String licensePlate;
  final String ownerId;

  const Vehicle({
    this.id = '',
    required this.brand,
    required this.model,
    required this.year,
    this.status = EVehicleStatus.active,
    this.vin = '',
    required this.licensePlate,
    required this.ownerId,
  });

  @override
  List<Object?> get props => [
    id,
    brand,
    model,
    year,
    status,
    vin,
    licensePlate,
    ownerId,
  ];
}