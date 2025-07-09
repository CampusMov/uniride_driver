import 'dart:developer';
import 'dart:io';

import 'package:uniride_driver/core/utils/resource.dart';

import 'package:uniride_driver/features/home/domain/entities/route_carpool.dart';

import 'package:uniride_driver/features/shared/domain/entities/location.dart';

import '../../domain/repositories/route_carpool_repository.dart';
import '../../domain/services/route_carpool_service.dart';
import '../model/route_carpool_update_current_location_request_model.dart';

class RouteCarpoolRepositoryImpl implements RouteCarpoolRepository {
  final RouteCarpoolService routeCarpoolService;

  RouteCarpoolRepositoryImpl({required this.routeCarpoolService});

  @override
  Future<Resource<RouteCarpool>> getRouteByCarpoolId(String carpoolId) async {
    try {
      log('TAG: RouteCarpoolRepository - Fetching route by carpool ID: $carpoolId');

      final routeResponse = await routeCarpoolService.getRouteByCarpoolId(carpoolId);
      final route = routeResponse.toDomain();

      log('TAG: RouteCarpoolRepository - Successfully fetched route with ID: ${route.id}');
      return Success(route);
    } on SocketException {
      log('TAG: RouteCarpoolRepository - Network error while fetching route by carpool ID');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: RouteCarpoolRepository - HTTP error while fetching route by carpool ID');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: RouteCarpoolRepository - Unexpected error while fetching route by carpool ID: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Resource<RouteCarpool>> getRouteById(String routeId) async{
    try {
      log('TAG: RouteCarpoolRepository - Fetching route by ID: $routeId');

      final routeResponse = await routeCarpoolService.getRouteById(routeId);
      final route = routeResponse.toDomain();

      log('TAG: RouteCarpoolRepository - Successfully fetched route with ID: ${route.id}');
      return Success(route);
    } on SocketException {
      log('TAG: RouteCarpoolRepository - Network error while fetching route by ID');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: RouteCarpoolRepository - HTTP error while fetching route by ID');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: RouteCarpoolRepository - Unexpected error while fetching route by ID: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Resource<RouteCarpool>> updateRouteCurrentLocation(String routeId, Location request) async {
    try {
      log('TAG: RouteCarpoolRepository - Updating current location for route ID: $routeId with location: $request');

      final requestModel = RouteCarpoolUpdateCurrentLocationRequestModel.fromDomain(request);
      final routeResponse = await routeCarpoolService.updateRouteCurrentLocation(routeId, requestModel);
      final updatedRoute = routeResponse.toDomain();

      log('TAG: RouteCarpoolRepository - Successfully updated current location for route ID: ${updatedRoute.id}');
      return Success(updatedRoute);
    } on SocketException {
      log('TAG: RouteCarpoolRepository - Network error while updating current location');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: RouteCarpoolRepository - HTTP error while updating current location');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: RouteCarpoolRepository - Unexpected error while updating current location: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }
}