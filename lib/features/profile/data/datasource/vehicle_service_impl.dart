import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../domain/services/vehicle_service.dart';
import '../model/vehicle_request_model.dart';
import '../model/vehicle_response_model.dart';

class VehicleServiceImpl implements VehicleService {
  final http.Client client;
  final String baseUrl;

  VehicleServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<VehicleResponseModel> createVehicle(VehicleRequestModel vehicleRequest) async {
    final uri = Uri.parse('$baseUrl/vehicles');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicleRequest.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return VehicleResponseModel.fromJson(jsonDecode(response.body));
    } else {
      log('TAG: VehicleServiceImpl: Error creating vehicle: ${response.body}');
      throw Exception('Error creating vehicle: ${response.body}');
    }
  }
}
