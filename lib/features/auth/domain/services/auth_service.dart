import 'package:uniride_driver/features/auth/data/models/auth_verification_code_response_model.dart';
import 'package:uniride_driver/features/auth/data/models/user_response_model.dart';

abstract class AuthService {
  Future<void> sendVerificationEmail(String email);
  Future<AuthVerificationCodeResponseModel> sendVerificationCode(
      String email,
      String code,
      String role,
  );
  Future<UserResponseModel> getUserById(String userId);
}