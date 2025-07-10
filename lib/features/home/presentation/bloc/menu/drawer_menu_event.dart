import 'package:equatable/equatable.dart';

abstract class DrawerMenuEvent extends Equatable {
  const DrawerMenuEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends DrawerMenuEvent {
  const LoadUserProfile();
}

class LogoutUser extends DrawerMenuEvent {
  const LogoutUser();
}