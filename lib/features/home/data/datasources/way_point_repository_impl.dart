import 'dart:developer';
import 'dart:io';

import 'package:uniride_driver/core/utils/resource.dart';

import '../../domain/entities/way_point.dart';
import '../../domain/repositories/way_point_repository.dart';
import '../../domain/services/way_point_service.dart';

class WayPointRepositoryImpl implements WayPointRepository {
  final WayPointService wayPointService;

  WayPointRepositoryImpl({required this.wayPointService});

  @override
  Future<Resource<List<WayPoint>>> getWayPointsByRouteId(String routeId) async {
    try {
      log('TAG: WayPointRepository - Fetching way points for route ID: $routeId');

      final wayPointsResponse = await wayPointService.getWayPointsByRouteId(routeId);
      final wayPoints = wayPointsResponse.map((e) => e.toDomain()).toList();

      log('TAG: WayPointRepository - Successfully fetched ${wayPoints.length} way points for route ID: $routeId');
      return Success(wayPoints);
    } on SocketException {
      log('TAG: WayPointRepository - Network error while fetching way points for route ID: $routeId');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: WayPointRepository - HTTP error while fetching way points for route ID: $routeId');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: WayPointRepository - Unexpected error while fetching way points for route ID: $routeId - $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }
}