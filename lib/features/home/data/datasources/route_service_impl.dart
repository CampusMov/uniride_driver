import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uniride_driver/features/home/data/model/route_request_model.dart';
import 'package:uniride_driver/features/home/data/model/route_response_model.dart';
import 'package:uniride_driver/features/home/domain/services/route_service.dart';

class RouteServiceImpl implements RouteService {
  final http.Client client;
  final String baseUrl;

  RouteServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<RouteResponseModel> getRoute(RouteRequestModel request) async {
    final uri = Uri.parse('$baseUrl/routes/shortest/a-star');

    log('TAG: RouteService - POST get route');
    log('TAG: RouteService - URL: $uri');
    log('TAG: RouteService - Request body: ${jsonEncode(request.toJson())}');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    log('TAG: RouteService - Response status: ${response.statusCode}');
    log('TAG: RouteService - Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return RouteResponseModel.fromJson(jsonResponse);
    } else {
      log('TAG: RouteServiceImpl: Error getting route: ${response.body}');
      throw Exception('Error getting route: ${response.statusCode}');
    }
  }
}