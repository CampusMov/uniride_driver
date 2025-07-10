import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uniride_driver/features/home/data/model/way_point_response_model.dart';
import 'package:uniride_driver/features/home/domain/services/way_point_service.dart';

class WayPointServiceImpl implements WayPointService {
  final http.Client client;
  final String baseUrl;

  WayPointServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<WayPointResponseModel>> getWayPointsByRouteId(String routeId) async {
    try {
      final uri = Uri.parse('$baseUrl/routes/$routeId/waypoints');

      log('TAG: WayPointServiceImpl - GET way points by route ID');
      log('TAG: WayPointServiceImpl - URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      log('TAG: WayPointServiceImpl - Response status: ${response.statusCode}');
      log('TAG: WayPointServiceImpl - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : [];
        return jsonList
            .map((json) => WayPointResponseModel.fromJson(json))
            .toList();
      } else {
        log('TAG: WayPointServiceImpl - Error fetching way points by route ID: ${response.body}');
        throw Exception('Error fetching way points by route ID: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: WayPointServiceImpl - Exception fetching way points by route ID: $e');
      throw Exception('Failed to get way points by route ID: $e');
    }
  }
}