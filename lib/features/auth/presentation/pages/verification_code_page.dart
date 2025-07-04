import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../blocs/verification_code_bloc.dart';
import '../blocs/verification_code_event.dart';
import '../blocs/verification_code_state.dart';

class VerificationCodePage extends StatelessWidget {
  const VerificationCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCodeBloc(
        authRepository: di.sl<AuthRepository>(),
        userRepository: di.sl<UserRepository>(),
      ),
      child: const _VerificationCodeView(),
    );
  }
}

class _VerificationCodeView extends StatelessWidget {
  const _VerificationCodeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCodeBloc, VerificationCodeState>(
      listener: (context, state) {
        if (state.isVerificationSuccess) {
          Navigator.of(context).pushReplacementNamed('/profile');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                child: Text(
                  'Ingresa el código',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              // Subtitle
              BlocBuilder<VerificationCodeBloc, VerificationCodeState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 40.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Text(
                      'Te enviamos un codigo para verificacion al ${state.user?.email ?? ''}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // OTP Input and messages
                      BlocBuilder<VerificationCodeBloc, VerificationCodeState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              // OTP Input or Loading
                              if (state.isLoading)
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              else
                                _buildOtpInput(context, state.code),

                              // Error message
                              if (state.isMessageErrorVisible && !state.isLoading)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    state.errorMessage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),

                              // Countdown message
                              if (state.secondsLeftToResendCode > 0 && !state.isLoading)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'Puedes reenviar el código en ${state.secondsLeftToResendCode} segundos',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      // Resend button
                      BlocBuilder<VerificationCodeBloc, VerificationCodeState>(
                        builder: (context, state) {
                          if (state.isButtonAvailable && !state.isLoading) {
                            return DefaultRoundedTextButton(
                              text: 'Reenviar código',
                              onPressed: () {
                                context.read<VerificationCodeBloc>().add(
                                  const ResendVerificationEmail(),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput(BuildContext context, String currentValue) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF3F4042),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: TextEditingController(text: currentValue),
        onChanged: (value) {
          context.read<VerificationCodeBloc>().add(
            CodeInputChanged(value),
          );
        },
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          letterSpacing: 8,
        ),
        decoration: const InputDecoration(
          hintText: '000000',
          hintStyle: TextStyle(
            color: Color(0xFFB3B3B3),
            letterSpacing: 8,
          ),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}