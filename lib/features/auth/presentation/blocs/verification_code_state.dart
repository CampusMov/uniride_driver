import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';

class VerificationCodeState extends Equatable {
  final String code;
  final String email;
  final User? user;
  final String errorMessage;
  final bool isLoading;
  final bool isButtonAvailable;
  final int secondsLeftToResendCode;
  final bool isMessageErrorVisible;
  final bool isVerificationSuccess;

  const VerificationCodeState({
    this.code = '',
    this.email = '',
    this.user,
    this.errorMessage = '',
    this.isLoading = false,
    this.isButtonAvailable = false,
    this.secondsLeftToResendCode = 0,
    this.isMessageErrorVisible = false,
    this.isVerificationSuccess = false,
  });

  VerificationCodeState copyWith({
    String? code,
    String? email,
    User? user,
    String? errorMessage,
    bool? isLoading,
    bool? isButtonAvailable,
    int? secondsLeftToResendCode,
    bool? isMessageErrorVisible,
    bool? isVerificationSuccess,
  }) {
    return VerificationCodeState(
      code: code ?? this.code,
      email: email ?? this.email,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isButtonAvailable: isButtonAvailable ?? this.isButtonAvailable,
      secondsLeftToResendCode: secondsLeftToResendCode ?? this.secondsLeftToResendCode,
      isMessageErrorVisible: isMessageErrorVisible ?? this.isMessageErrorVisible,
      isVerificationSuccess: isVerificationSuccess ?? this.isVerificationSuccess,
    );
  }

  @override
  List<Object?> get props => [
    code,
    email,
    user,
    errorMessage,
    isLoading,
    isButtonAvailable,
    secondsLeftToResendCode,
    isMessageErrorVisible,
    isVerificationSuccess,
  ];
}