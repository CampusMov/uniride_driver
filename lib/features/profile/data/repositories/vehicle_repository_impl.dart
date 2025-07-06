import 'dart:developer';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/services/vehicle_service.dart';
import '../model/vehicle_request_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleService vehicleService;

  VehicleRepositoryImpl({required this.vehicleService});

  @override
  Future<Resource<Vehicle>> createVehicle(Vehicle vehicle) async {
    try {
      final response = await vehicleService.createVehicle(
        VehicleRequestModel.fromDomain(vehicle),
      );
      log('TAG: VehicleRepositoryImpl: Vehicle created successfully');
      return Success(response.toDomain());
    } catch (e) {
      log('TAG: VehicleRepositoryImpl: Error creating vehicle: $e');
      return Failure(e.toString());
    }
  }
}