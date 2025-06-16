import 'package:uniride_driver/features/auth/data/models/auth_verification_response.dart';

abstract class AuthRepository {
  Future<void> sendVerificationEmail(String email);
  Future<AuthVerificationResponseDto> sendVerificationCode({
    required String email,
    required String verificationCode,
    required String role,
  });
}