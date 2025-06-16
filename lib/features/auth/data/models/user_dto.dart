import 'package:uniride_driver/features/auth/domain/entities/user_role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';

class UserDto {
  final String id;
  final String name;
  final String email;
  final String role;

  UserDto({required this.id, required this.name, required this.email, required this.role});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
      );

  User toEntity() => User(
        id: id,
        name: name,
        email: email,
        role: UserRoleExtension.fromString(role),
      );

  toJson() {}
}