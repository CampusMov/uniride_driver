import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.status,
    required super.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '1',
      email: json['email'] ?? '',
      status: UserStatus.fromString(json['status'] ?? 'NOT_VERIFIED'),
      roles: json['rol'] ?? [Role.fromString('DRIVER')],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'status': status.value,
      'rol': roles.first.value,
    };
  }

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      status: user.status,
      roles: user.roles,
    );
  }
}