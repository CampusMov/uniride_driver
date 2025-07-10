import 'package:uniride_driver/features/home/data/model/route_carpool_response_model.dart';
import 'package:uniride_driver/features/home/data/model/route_carpool_update_current_location_request_model.dart';

abstract class RouteCarpoolService {
  Future<RouteCarpoolResponseModel> getRouteById(String routeId);
  Future<RouteCarpoolResponseModel> getRouteByCarpoolId(String carpoolId);
  Future<RouteCarpoolResponseModel> updateRouteCurrentLocation(String routeId, RouteCarpoolUpdateCurrentLocationRequestModel request);
}