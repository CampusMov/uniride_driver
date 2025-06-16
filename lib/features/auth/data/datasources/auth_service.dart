import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/features/auth/data/models/auth_verification_response.dart';

class AuthService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<void> sendVerificationEmail(String email) async {
    final uri = Uri.parse('$baseUrl/auth/institutional-email-verification');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email},
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Error al enviar email: ${response.body}');
    }
  }

  Future<AuthVerificationResponseDto> sendVerificationCode({
    required String email,
    required String verificationCode,
    required String role,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/code-verification');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'verificationCode': verificationCode,
        'role': role,
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return AuthVerificationResponseDto.fromJson(json);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
