import 'dart:developer';

import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/repositories/auth_repository.dart';
import 'package:uniride_driver/features/auth/domain/repositories/user_repository.dart';
import 'package:uniride_driver/features/auth/presentation/blocs/institutional_email_event.dart';
import 'package:uniride_driver/features/auth/presentation/blocs/institutional_email_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstitutionalEmailBloc extends Bloc<InstitutionalEmailEvent, InstitutionalEmailState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  InstitutionalEmailBloc({
    required this.authRepository,
    required this.userRepository,
  }) : super(const InstitutionalEmailState()) {
    on<EmailInputChanged>(_onEmailInputChanged);
    on<SendVerificationEmailRequested>(_onSendVerificationEmailRequested);
  }

  void _onEmailInputChanged(
      EmailInputChanged event,
      Emitter<InstitutionalEmailState> emit,
      ) {
    final trimmedEmail = event.email.trim();
    final isValid = _isEmailValid(trimmedEmail);

    emit(state.copyWith(
      email: trimmedEmail,
      isButtonAvailable: isValid,
    ));
  }

  Future<void> _onSendVerificationEmailRequested(
      SendVerificationEmailRequested event,
      Emitter<InstitutionalEmailState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      isButtonAvailable: false,
    ));

    try {
      // Delete all users locally first
      await userRepository.deleteAllUsersLocally();
      log('All users deleted locally');

      // Send verification email
      final result = await authRepository.verifyEmail(state.email);

      if (result is Success<void>) {
        log('Verification email sent successfully');

        // Save user locally
        await _saveUserLocally(state.email);

        emit(state.copyWith(
          isLoading: false,
          isEmailSent: true,
          email: '', // Clear email after success
        ));
      } else if (result is Failure<void>) {
        log('Error sending verification email: ${result.message}');
        emit(state.copyWith(
          isLoading: false,
          isButtonAvailable: true,
          errorMessage: result.message,
          email: '', // Clear email after error
        ));
      }
    } catch (e) {
      log('Exception in _onSendVerificationEmailRequested: $e');
      emit(state.copyWith(
        isLoading: false,
        isButtonAvailable: true,
        errorMessage: 'Error inesperado',
        email: '', // Clear email after error
      ));
    }
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final universityDomainRegex = RegExp(r'[a-zA-Z0-9]+\.edu\.pe$');

    if (!emailRegex.hasMatch(email)) return false;

    final domain = email.split('@').last;
    return universityDomainRegex.hasMatch(domain);
  }

  Future<void> _saveUserLocally(String email) async {
    final user = User(email: email);
    await userRepository.saveUserLocally(user);
    log('User saved locally: ${user.email}');
  }
}
