import 'package:uniride_driver/features/home/data/model/carpool_request_model.dart';
import 'package:uniride_driver/features/home/data/model/carpool_response_model.dart';
import 'package:uniride_driver/features/home/data/model/location_request_model.dart';

abstract class CarpoolService {
  Future<CarpoolResponseModel> createCarpool(CarpoolRequestModel request);
  Future<CarpoolResponseModel> getCarpoolById(String carpoolId);
  Future<CarpoolResponseModel> startCarpool(String carpoolId, LocationRequestModel request);
}