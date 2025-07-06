import '../../data/model/vehicle_request_model.dart';
import '../../data/model/vehicle_response_model.dart';

abstract class VehicleService {
  Future<VehicleResponseModel> createVehicle(VehicleRequestModel vehicleRequest);
}