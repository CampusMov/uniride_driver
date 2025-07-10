import 'package:uniride_driver/features/home/data/model/way_point_response_model.dart';

abstract class WayPointService {
  Future<List<WayPointResponseModel>> getWayPointsByRouteId(String routeId);
}