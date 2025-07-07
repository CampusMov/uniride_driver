import '../../../../core/utils/resource.dart';
import '../entities/route.dart';

abstract class RouteRepository {
  Future<Resource<Route>> getRoute(double startLatitude, double startLongitude,double endLatitude, double endLongitude);
}