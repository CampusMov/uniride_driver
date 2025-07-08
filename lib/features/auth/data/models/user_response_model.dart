
import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';

class UserResponseModel{
  final String id;
  final String email;
  final String status;
  final List<String> roles;

  UserResponseModel({
    required this.id,
    required this.email,
    required this.status,
    required this.roles
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      status: UserStatus.fromString(status),
      roles: roles.map((role) => Role.fromString(role)).toList(),
    );
  }

}