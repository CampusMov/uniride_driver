import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/auth/data/models/auth_verification_response.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Resource<void>> verifyEmail(String email);
  Future<Resource<AuthVerificationCodeResponse>> verifyCode({
    required String email,
    required String code,
    required String role,
  });
  Future<Resource<User>> getUserById(String userId);
}