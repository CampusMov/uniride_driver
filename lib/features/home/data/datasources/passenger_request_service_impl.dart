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
      final uri = Uri.parse('$baseUrl/passenger-requests?carpoolId=$carpoolId');

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

  @override
  Future<PassengerRequestResponseModel> acceptPassengerRequest(String passengerRequestId) async {
    try {
      final uri = Uri.parse('$baseUrl/passenger-requests/$passengerRequestId/accept');

      log('TAG: PassengerRequestService - POST accept passenger request');
      log('TAG: PassengerRequestService - URL: $uri');

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      log('TAG: PassengerRequestService - Response status: ${response.statusCode}');
      log('TAG: PassengerRequestService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Future.value(PassengerRequestResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        log('TAG: PassengerRequestService - Error accepting passenger request: ${response.body}');
        throw Exception('Error accepting passenger request: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: PassengerRequestService - Exception accepting passenger request: $e');
      throw Exception('Failed to accept passenger request: $e');
    }
  }

  @override
  Future<PassengerRequestResponseModel> rejectPassengerRequest(String passengerRequestId) async {
    try {
      final uri = Uri.parse('$baseUrl/passenger-requests/$passengerRequestId/reject');

      log('TAG: PassengerRequestService - POST reject passenger request');
      log('TAG: PassengerRequestService - URL: $uri');

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      log('TAG: PassengerRequestService - Response status: ${response.statusCode}');
      log('TAG: PassengerRequestService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Future.value(PassengerRequestResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        log('TAG: PassengerRequestService - Error rejecting passenger request: ${response.body}');
        throw Exception('Error rejecting passenger request: ${response.statusCode}');
      }
    } catch (e) {
      log('TAG: PassengerRequestService - Exception rejecting passenger request: $e');
      throw Exception('Failed to reject passenger request: $e');
    }
  }

}