import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uniride_driver/features/home/data/model/passenger_request_response_model.dart';

import '../../domain/services/passenger_request_service.dart';

class PassengerRequestServiceImpl implements PassengerRequestService {
  final http.Client client;
  final String baseUrl;

  PassengerRequestServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<PassengerRequestResponseModel>> getPassengerRequestsByCarpoolId(String carpoolId) async {
    try {
      final uri = Uri.parse('$baseUrl/carpools/$carpoolId/passenger-requests');

      log('TAG: PassengerRequestService - GET passenger requests by carpool');
      log('TAG: PassengerRequestService - URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      log('TAG: PassengerRequestService - Response status: ${response.statusCode}');
      log('TAG: PassengerRequestService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =  jsonDecode(response.body);
        return jsonList
            .map((json) => PassengerRequestResponseModel.fromJson(json))
            .toList();
      } else {
        log('TAG: PassengerRequestService - Error fetching passenger requests: ${response.body}');
        throw Exception('Error fetching passenger requests: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: PassengerRequestService - Exception fetching passenger requests: $e');
      throw Exception('Failed to fetch passenger requests: $e');
    }
  }

}