import 'dart:developer';
import 'dart:io';

import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/home/domain/entities/route.dart';
import 'package:uniride_driver/features/home/domain/services/route_service.dart';

import '../../domain/repositories/route_repository.dart';
import '../model/route_request_model.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteService routeService;

  RouteRepositoryImpl({required this.routeService});

  @override
  Future<Resource<Route>> getRoute(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
    try {
      log('TAG: RouteRepository - Fetching route from ($startLatitude, $startLongitude) to ($endLatitude, $endLongitude)');
      final requestModel = RouteRequestModel(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );
      final routeResponse = await routeService.getRoute(requestModel);
      final route = routeResponse.toDomain();
      log('TAG: RouteRepository - Successfully fetched route with ${route.intersections.length} intersections, total distance: ${route.totalDistance}, total duration: ${route.totalDuration}');
      return Success(route);
    } on SocketException {
      log('TAG: RouteRepository - Network error while fetching route');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: RouteRepository - HTTP error while fetching route');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: RouteRepository - Unexpected error while fetching route: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }
}