import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/auth/domain/entities/role.dart';
import 'package:uniride_driver/features/auth/domain/entities/user_status.dart';

class User extends Equatable {
  final String id;
  final String email;
  final UserStatus status;
  final List<Role> roles;

  const User({
    this.id = '1',
    this.email = '',
    this.status = UserStatus.notVerified,
    this.roles = const [Role.driver],
  });

  @override
  List<Object> get props => [id, email, status, roles];
}