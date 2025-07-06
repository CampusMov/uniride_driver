import 'package:uniride_driver/features/profile/domain/entities/vehicle.dart';

import '../../domain/entities/enum_vehicle_status.dart';

class VehicleResponseModel {
  final String? id;
  final String? brand;
  final String? model;
  final int? year;
  final String? status;
  final String? vin;
  final String? licensePlate;
  final String? ownerId;

  const VehicleResponseModel({
    this.id,
    this.brand,
    this.model,
    this.year,
    this.status,
    this.vin,
    this.licensePlate,
    this.ownerId,
  });

  factory VehicleResponseModel.fromJson(Map<String, dynamic> json) {
    return VehicleResponseModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      status: json['status'],
      vin: json['vin'],
      licensePlate: json['licensePlate'],
      ownerId: json['ownerId'],
    );
  }

  Vehicle toDomain() {
    return Vehicle(
      id: id ?? '',
      brand: brand ?? '',
      model: model ?? '',
      year: year ?? DateTime.now().year,
      status: EVehicleStatus.fromString(status),
      vin: vin ?? '',
      licensePlate: licensePlate ?? '',
      ownerId: ownerId ?? '',
    );
  }
}