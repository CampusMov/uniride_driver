import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';

class SkipLoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isUserLoaded;
  final User? user;

  const SkipLoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isUserLoaded = false,
    this.user,
  });

  SkipLoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isUserLoaded,
    User? user,
  }) {
    return SkipLoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isUserLoaded: isUserLoaded ?? this.isUserLoaded,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    isUserLoaded,
    user,
  ];
}