import 'package:uniride_driver/features/home/data/model/passenger_request_response_model.dart';

abstract class PassengerRequestService {
  Future<List<PassengerRequestResponseModel>> getPassengerRequestsByCarpoolId(String carpoolId);
  Future<PassengerRequestResponseModel> acceptPassengerRequest(String passengerRequestId);
  Future<PassengerRequestResponseModel> rejectPassengerRequest(String passengerRequestId);
}