import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../model/profile_request_model.dart';
import '../model/profile_response_model.dart';
import '../../domain/services/profile_service.dart';

class ProfileServiceImpl implements ProfileService {
  final http.Client client;
  final String baseUrl;

  ProfileServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<void> saveProfile(ProfileRequestModel profileRequest) async {
    final uri = Uri.parse('$baseUrl/profiles');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profileRequest.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      log('TAG: ProfileServiceImpl: Error saving profile: ${response.body}');
      throw Exception('Error saving profile: ${response.body}');
    }
  }

  @override
  Future<ProfileResponseModel> getProfileById(String profileId) async {
    final uri = Uri.parse('$baseUrl/profiles/$profileId');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return ProfileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      log('TAG: ProfileServiceImpl: Error fetching profile: ${response.body}');
      throw Exception('Error fetching profile: ${response.body}');
    }
  }
}