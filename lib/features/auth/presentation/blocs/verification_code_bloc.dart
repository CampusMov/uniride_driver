import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/presentation/blocs/verification_code_event.dart';
import 'package:uniride_driver/features/auth/presentation/blocs/verification_code_state.dart';

import '../../../../core/utils/resource.dart';
import '../../data/models/auth_verification_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';

class VerificationCodeBloc extends Bloc<VerificationCodeEvent, VerificationCodeState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  Timer? _countdownTimer;
  Timer? _errorTimer;

  VerificationCodeBloc({
    required this.authRepository,
    required this.userRepository,
  }) : super(const VerificationCodeState()) {
    on<CodeInputChanged>(_onCodeInputChanged);
    on<SendVerificationCode>(_onSendVerificationCode);
    on<ResendVerificationEmail>(_onResendVerificationEmail);
    on<LoadUserLocally>(_onLoadUserLocally);
    on<StartCountdown>(_onStartCountdown);
    on<CountdownTick>(_onCountdownTick);
    on<HideErrorMessage>(_onHideErrorMessage);

    // Initialize by loading user locally and starting countdown
    add(const LoadUserLocally());
    add(const StartCountdown());
  }

  void _onCodeInputChanged(CodeInputChanged event, Emitter<VerificationCodeState> emit) {
    emit(state.copyWith(code: event.code.trim()));

    // Auto-verify if code is complete
    if (_isCodeValid(event.code.trim())) {
      add(const SendVerificationCode());
    }
  }

  void _onSendVerificationCode(SendVerificationCode event, Emitter<VerificationCodeState> emit) async {
    if (!_isCodeValid(state.code)) {
      _showErrorMessage('El código debe tener 6 dígitos', emit);
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      isButtonAvailable: false,
    ));

    try {
      final result = await authRepository.verifyCode(
        email: state.user?.email ?? '',
        code: state.code,
        role: 'driver',
      );

      switch (result) {
        case Success<AuthVerificationCodeResponse>():
          await _deleteAllUsersLocally();
          await _insertUserLocally(result.data.toDomain());

          emit(state.copyWith(
            isLoading: false,
            isButtonAvailable: true,
            code: '',
            isVerificationSuccess: true,
          ));
          break;

        case Failure<AuthVerificationCodeResponse>():
          emit(state.copyWith(
            isLoading: false,
            isButtonAvailable: true,
            code: '',
          ));
          _showErrorMessage('Error al verificar el código', emit);
          break;

        case Loading<AuthVerificationCodeResponse>():
        // Already handled by setting isLoading to true
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isButtonAvailable: true,
        code: '',
      ));
      _showErrorMessage('Error al verificar el código', emit);
    }
  }

  void _onResendVerificationEmail(ResendVerificationEmail event, Emitter<VerificationCodeState> emit) async {
    if (state.user?.email == null || state.user!.email.isEmpty) return;

    emit(state.copyWith(
      isLoading: true,
      isButtonAvailable: false,
    ));

    try {
      final result = await authRepository.verifyEmail(state.user!.email);

      switch (result) {
        case Success<void>():
          emit(state.copyWith(
            isLoading: false,
            code: '',
          ));
          add(const StartCountdown());
          break;

        case Failure<void>():
          emit(state.copyWith(
            isLoading: false,
            isButtonAvailable: false,
            code: '',
          ));
          _showErrorMessage('Error al reenviar el código', emit);
          break;

        case Loading<void>():
        // Already handled by setting isLoading to true
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isButtonAvailable: false,
        code: '',
      ));
      _showErrorMessage('Error al reenviar el código', emit);
    }
  }

  void _onLoadUserLocally(LoadUserLocally event, Emitter<VerificationCodeState> emit) async {
    try {
      final user = await userRepository.getUserLocally();

      if (user != null) {
        log('TAG: VerificationCodeBloc: User loaded locally: ${user.email}');
        emit(state.copyWith(user: user));
      }
    } catch (e) {
      log('TAG: VerificationCodeBloc: Error loading user locally: $e');
      _showErrorMessage('Error al cargar usuario local', emit);
    }
  }

  void _onStartCountdown(StartCountdown event, Emitter<VerificationCodeState> emit) {
    _countdownTimer?.cancel();

    emit(state.copyWith(
      secondsLeftToResendCode: 60,
      isButtonAvailable: false,
    ));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final secondsLeft = 60 - timer.tick;

      if (secondsLeft <= 0) {
        timer.cancel();
        add(const CountdownTick(0));
      } else {
        add(CountdownTick(secondsLeft));
      }
    });
  }

  void _onCountdownTick(CountdownTick event, Emitter<VerificationCodeState> emit) {
    emit(state.copyWith(
      secondsLeftToResendCode: event.secondsLeft,
      isButtonAvailable: event.secondsLeft == 0,
    ));
  }

  void _onHideErrorMessage(HideErrorMessage event, Emitter<VerificationCodeState> emit) {
    emit(state.copyWith(
      isMessageErrorVisible: false,
      errorMessage: '',
    ));
  }

  bool _isCodeValid(String code) {
    return code.isNotEmpty &&
        code.length == 6 &&
        code.split('').every((char) => '0123456789'.contains(char));
  }

  void _showErrorMessage(String message, Emitter<VerificationCodeState> emit) {
    _errorTimer?.cancel();

    emit(state.copyWith(
      errorMessage: message,
      isMessageErrorVisible: true,
    ));

    _errorTimer = Timer(const Duration(seconds: 5), () {
      add(const HideErrorMessage());
    });
  }

  Future<void> _deleteAllUsersLocally() async {
    await userRepository.deleteAllUsersLocally();
  }

  Future<void> _insertUserLocally(User user) async {
    await userRepository.saveUserLocally(user);
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _errorTimer?.cancel();
    return super.close();
  }
}
