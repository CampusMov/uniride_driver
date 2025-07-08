import 'package:uniride_driver/features/home/data/model/passenger_request_response_model.dart';

abstract class PassengerRequestService {
  Future<List<PassengerRequestResponseModel>> getPassengerRequestsByCarpoolId(String carpoolId);
}