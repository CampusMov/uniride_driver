import 'package:equatable/equatable.dart';

class InstitutionalEmailState extends Equatable {
  final String email;
  final bool isLoading;
  final bool isButtonAvailable;
  final String? errorMessage;
  final bool isEmailSent;

  const InstitutionalEmailState({
    this.email = '',
    this.isLoading = false,
    this.isButtonAvailable = false,
    this.errorMessage,
    this.isEmailSent = false,
  });

  InstitutionalEmailState copyWith({
    String? email,
    bool? isLoading,
    bool? isButtonAvailable,
    String? errorMessage,
    bool? isEmailSent,
  }) {
    return InstitutionalEmailState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isButtonAvailable: isButtonAvailable ?? this.isButtonAvailable,
      errorMessage: errorMessage,
      isEmailSent: isEmailSent ?? this.isEmailSent,
    );
  }

  @override
  List<Object?> get props => [
    email,
    isLoading,
    isButtonAvailable,
    errorMessage,
    isEmailSent,
  ];
}