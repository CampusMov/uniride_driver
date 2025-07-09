import 'package:equatable/equatable.dart';

abstract class SkipLoginEvent extends Equatable{
  const SkipLoginEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserLocally extends SkipLoginEvent {
  const LoadUserLocally();
}

class LoadUserById extends SkipLoginEvent {
  final String userId;
  const LoadUserById(this.userId);
}