
import 'package:uniride_driver/features/auth/data/models/auth_verification_response.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';

class AuthVerificationCodeResponseModel extends AuthVerificationCodeResponse {
  const AuthVerificationCodeResponseModel({
    required super.id,
    required super.email,
    required super.status,
    required super.roles,
  });

  factory AuthVerificationCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthVerificationCodeResponseModel(
      id: json['id'],
      email: json['email'],
      status: json['status'] != null ? UserStatus.fromString(json['status']) : null,
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'status': status?.value,
      'roles': roles,
    };
  }
}