import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uniride_driver/features/home/data/model/route_carpool_response_model.dart';
import 'package:uniride_driver/features/home/data/model/route_carpool_update_current_location_request_model.dart';
import 'package:uniride_driver/features/home/domain/services/route_carpool_service.dart';

class RouteCarpoolServiceImpl implements RouteCarpoolService {
  final http.Client client;
  final String baseUrl;

  RouteCarpoolServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<RouteCarpoolResponseModel> getRouteByCarpoolId(String carpoolId) async {
    try {
      final uri = Uri.parse('$baseUrl/routes?carpoolId=$carpoolId');

      log('TAG: RouteCarpoolService - GET route by carpool ID');
      log('TAG: RouteCarpoolService - URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      log('TAG: RouteCarpoolService - Response status: ${response.statusCode}');
      log('TAG: RouteCarpoolService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Future.value(RouteCarpoolResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        log('TAG: RouteCarpoolService - Error fetching route by carpool ID: ${response.body}');
        throw Exception('Error fetching route by carpool ID: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: RouteCarpoolService - Exception fetching route by carpool ID: $e');
      throw Exception('Failed to get route by carpool ID: $e');
    }
  }

  @override
  Future<RouteCarpoolResponseModel> getRouteById(String routeId) async {
    try {
      final uri = Uri.parse('$baseUrl/routes/$routeId');

      log('TAG: RouteCarpoolService - GET route by ID');
      log('TAG: RouteCarpoolService - URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      log('TAG: RouteCarpoolService - Response status: ${response.statusCode}');
      log('TAG: RouteCarpoolService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Future.value(RouteCarpoolResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        log('TAG: RouteCarpoolService - Error fetching route by ID: ${response.body}');
        throw Exception('Error fetching route by ID: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: RouteCarpoolService - Exception fetching route by ID: $e');
      throw Exception('Failed to get route by ID: $e');
    }
  }

  @override
  Future<RouteCarpoolResponseModel> updateRouteCurrentLocation(String routeId, RouteCarpoolUpdateCurrentLocationRequestModel request) async {
    try {
      final uri = Uri.parse('$baseUrl/routes/$routeId/current-location');

      log('TAG: RouteCarpoolService - POST update route current location');
      log('TAG: RouteCarpoolService - URL: $uri');
      log('TAG: RouteCarpoolService - Request body: ${jsonEncode(request.toJson())}');

      final response = await client.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      log('TAG: RouteCarpoolService - Response status: ${response.statusCode}');
      log('TAG: RouteCarpoolService - Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Future.value(RouteCarpoolResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        log('TAG: RouteCarpoolService - Error updating route current location: ${response.body}');
        throw Exception('Error updating route current location: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: RouteCarpoolService - Exception updating route current location: $e');
      throw Exception('Failed to update route current location: $e');
    }
  }

}