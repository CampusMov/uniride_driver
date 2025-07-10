import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:uniride_driver/features/auth/data/models/auth_verification_code_response_model.dart';
import 'package:uniride_driver/features/auth/data/models/user_response_model.dart';

import '../../domain/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final http.Client client;
  final String baseUrl;

  AuthServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<void> sendVerificationEmail(String email) async {
    final uri = Uri
        .parse('$baseUrl/auth/institutional-email-verification')
        .replace(
      queryParameters: {'email': email},
    );

    final response = await client.post(uri);

    if (response.statusCode != 200) {
      throw Exception('Error al enviar el correo de verificación');
    }
  }

  @override
  Future<AuthVerificationCodeResponseModel> sendVerificationCode(String email, String code, String role) async {
    final uri = Uri.parse('$baseUrl/auth/code-verification').replace(
      queryParameters: {
        'email': email,
        'verificationCode': code,
        'role': role,
      },
    );

    final response = await client.post(uri);

    if (response.statusCode == 200) {
      return AuthVerificationCodeResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Error al verificar el código');
    }
  }

  @override
  Future<UserResponseModel> getUserById(String userId) async {
    final uri = Uri.parse('$baseUrl/auth/institutional-email-verification/$userId');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return UserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      log('TAG: AuthServiceImpl: Error al obtener el usuario: ${response.body}');
      throw Exception('Error al obtener el usuario: ${response.body}');
    }
  }

}
