import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';

class AuthVerificationCodeResponse extends Equatable {
  final String? id;
  final String? email;
  final UserStatus? status;
  final List<String>? roles;

  const AuthVerificationCodeResponse({
    this.id,
    this.email,
    this.status,
    this.roles,
  });

  User toDomain() {
    return User(
      id: id ?? '',
      email: email ?? '',
      status: status ?? UserStatus.notVerified,
      roles: roles?.map((role) => Role.fromString(role)).toList() ?? [Role.passenger],
    );
  }

  @override
  List<Object?> get props => [id, email, status, roles];
}