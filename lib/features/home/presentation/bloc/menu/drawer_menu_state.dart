import 'package:equatable/equatable.dart';

import '../../../../../core/utils/resource.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../../profile/domain/entities/profile.dart';

enum DrawerMenuStatus { initial, loading, loaded, error, loggingOut, loggedOut }

class DrawerMenuState extends Equatable {
  final DrawerMenuStatus status;
  final User? user;
  final Profile? profile;
  final String? errorMessage;
  final Resource<void>? logoutResult;

  const DrawerMenuState({
    this.status = DrawerMenuStatus.initial,
    this.user,
    this.profile,
    this.errorMessage,
    this.logoutResult,
  });

  DrawerMenuState copyWith({
    DrawerMenuStatus? status,
    User? user,
    Profile? profile,
    String? errorMessage,
    Resource<void>? logoutResult,
  }) {
    return DrawerMenuState(
      status: status ?? this.status,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      logoutResult: logoutResult ?? this.logoutResult,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    profile,
    errorMessage,
    logoutResult,
  ];
}