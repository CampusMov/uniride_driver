import 'package:uniride_driver/features/home/data/model/route_response_model.dart';

import '../../data/model/route_request_model.dart';

abstract class RouteService {
  Future<RouteResponseModel> getRoute(RouteRequestModel request);
}