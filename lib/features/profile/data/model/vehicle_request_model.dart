import 'package:uniride_driver/features/profile/domain/entities/vehicle.dart';

class VehicleRequestModel {
  final String brand;
  final String model;
  final int year;
  final String status;
  final String vin;
  final String licensePlate;
  final String ownerId;

  const VehicleRequestModel({
    required this.brand,
    required this.model,
    required this.year,
    required this.status,
    required this.vin,
    required this.licensePlate,
    required this.ownerId,
  });

  factory VehicleRequestModel.fromDomain(Vehicle vehicle) {
    return VehicleRequestModel(
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      status: vehicle.status.value,
      vin: vehicle.vin,
      licensePlate: vehicle.licensePlate,
      ownerId: vehicle.ownerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'year': year,
      'status': status,
      'vin': vin,
      'licensePlate': licensePlate,
      'ownerId': ownerId,
    };
  }
}