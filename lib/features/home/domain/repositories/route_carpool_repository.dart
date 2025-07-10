import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/home/domain/entities/route_carpool.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

abstract class RouteCarpoolRepository {
  Future<Resource<RouteCarpool>> getRouteById(String routeId);
  Future<Resource<RouteCarpool>> getRouteByCarpoolId(String carpoolId);
  Future<Resource<RouteCarpool>> updateRouteCurrentLocation(String routeId, Location request);
}