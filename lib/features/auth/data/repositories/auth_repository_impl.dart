import 'package:uniride_driver/features/auth/data/datasources/auth_service.dart';
import 'package:uniride_driver/features/auth/data/models/auth_verification_response.dart';
import 'package:uniride_driver/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  AuthRepositoryImpl({required this.authService});

  @override
  Future<void> sendVerificationEmail(String email) async {
    await authService.sendVerificationEmail(email);
  }
  @override
  Future<AuthVerificationResponseDto> sendVerificationCode({
    required String email,
    required String verificationCode,
    required String role,
  }) async {
    final response = await authService.sendVerificationCode(
      email: email,
      verificationCode: verificationCode,
      role: role,
    );
    return response;
  }
}