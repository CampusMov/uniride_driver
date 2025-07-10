import 'dart:developer';

import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/auth/data/models/auth_verification_response.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/repositories/auth_repository.dart';
import 'package:uniride_driver/features/auth/domain/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  AuthRepositoryImpl({required this.authService});

  @override
  Future<Resource<AuthVerificationCodeResponse>> verifyCode({required String email, required String code, required String role}) async {
    try {
      final result = await authService.sendVerificationCode(email, code, role);
      log('TAG: AuthRepositoryImpl: Verification code sent for $email with role $role');
      return Success(result);
    } catch (e) {
      log('TAG: AuthRepositoryImpl: Error sending verification code: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<void>> verifyEmail(String email) async {
    try {
      await authService.sendVerificationEmail(email);
      log('TAG: AuthRepositoryImpl: Verification email sent for $email');
      return const Success(null);
    } catch (e) {
      log('TAG: AuthRepositoryImpl: Error sending verification email: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<User>> getUserById(String userId) async {
    try{
      final response = await authService.getUserById(userId);
      log('TAG: AuthRepositoryImpl: User fetched successfully for ID: $userId');
      return Success(response.toDomain());
    } catch (e) {
      log('TAG: AuthRepositoryImpl: Error fetching user: $e');
      return Failure(e.toString());
    }
  }
}