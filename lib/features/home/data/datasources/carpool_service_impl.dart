import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uniride_driver/features/home/data/model/carpool_request_model.dart';
import 'package:uniride_driver/features/home/data/model/carpool_response_model.dart';
import 'package:uniride_driver/features/home/data/model/location_request_model.dart';

import '../../domain/services/carpool_service.dart';

class CarpoolServiceImpl implements CarpoolService {
  final http.Client client;
  final String baseUrl;

  CarpoolServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<CarpoolResponseModel> createCarpool(CarpoolRequestModel request) async {
    try {
      final uri = Uri.parse('$baseUrl/carpools');

      log('TAG: CarpoolService - POST create carpool');
      log('TAG: CarpoolService - URL: $uri');
      log('TAG: CarpoolService - Request body: ${jsonEncode(request.toJson())}');

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json',},
        body: jsonEncode(request.toJson()),
      );

      log('TAG: CarpoolService - Response status: ${response.statusCode}');
      log('TAG: CarpoolService - Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return CarpoolResponseModel.fromJson(jsonResponse);
      } else {
        log('TAG: CarpoolServiceImpl: Error creating carpool: ${response.body}');
        throw Exception('Error creating carpool: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: CarpoolServiceImpl: Exception creating carpool: $e');
      throw Exception('Failed to create carpool: $e');
    }
  }

  @override
  Future<CarpoolResponseModel> getCarpoolById(String carpoolId) async {
    try {
      final uri = Uri.parse('$baseUrl/carpools/$carpoolId');

      log('TAG: CarpoolService - GET carpool by ID');
      log('TAG: CarpoolService - URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json',},
      );

      log('TAG: CarpoolService - Response status: ${response.statusCode}');
      log('TAG: CarpoolService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return CarpoolResponseModel.fromJson(jsonResponse);
      } else {
        log('TAG: CarpoolServiceImpl: Error fetching carpool by ID: ${response.body}');
        throw Exception('Error fetching carpool by ID: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: CarpoolServiceImpl: Exception fetching carpool by ID: $e');
      throw Exception('Failed to fetch carpool by ID: $e');
    }
  }

  @override
  Future<CarpoolResponseModel> startCarpool(String carpoolId, LocationRequestModel request) async {
    try {
      final uri = Uri.parse('$baseUrl/carpools/$carpoolId/start');

      log('TAG: CarpoolService - POST start carpool');
      log('TAG: CarpoolService - URL: $uri');
      log('TAG: CarpoolService - Request body: ${jsonEncode(request.toJson())}');

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json',},
        body: jsonEncode(request.toJson()),
      );

      log('TAG: CarpoolService - Response status: ${response.statusCode}');
      log('TAG: CarpoolService - Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Future.value(CarpoolResponseModel.fromJson(jsonResponse));
      } else {
        log('TAG: CarpoolServiceImpl: Error starting carpool: ${response.body}');
        throw Exception('Error starting carpool: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: CarpoolServiceImpl: Exception starting carpool: $e');
      throw Exception('Failed to start carpool: $e');
    }
  }
}
