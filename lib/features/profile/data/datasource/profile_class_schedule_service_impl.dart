import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../domain/services/profile_class_schedule_service.dart';
import '../model/class_schedule_response_model.dart';

class ProfileClassScheduleServiceImpl implements ProfileClassScheduleService {
  final http.Client client;
  final String baseUrl;

  ProfileClassScheduleServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<ClassScheduleResponseModel>> getClassSchedulesByProfileId(String profileId) async {
    final uri = Uri.parse('$baseUrl/profile-service/profiles/$profileId/class-schedules');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => ClassScheduleResponseModel.fromJson(json))
          .toList();
    } else {
      log('TAG: ProfileClassScheduleServiceImpl: Error fetching class schedules: ${response.body}');
      throw Exception('Error fetching class schedules: ${response.body}');
    }
  }
}