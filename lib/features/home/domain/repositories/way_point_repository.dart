import 'package:uniride_driver/core/utils/resource.dart';

import '../entities/way_point.dart';

abstract class WayPointRepository {
  Future<Resource<List<WayPoint>>> getWayPointsByRouteId(String routeId);
}