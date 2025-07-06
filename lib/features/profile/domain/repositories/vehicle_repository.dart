import '../../../../core/utils/resource.dart';
import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<Resource<Vehicle>> createVehicle(Vehicle vehicle);
}