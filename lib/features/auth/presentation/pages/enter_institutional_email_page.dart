import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/navigation/screens_routes.dart';
import 'package:uniride_driver/features/auth/domain/repositories/auth_repository.dart';
import 'package:uniride_driver/features/auth/domain/repositories/user_repository.dart';
import 'package:uniride_driver/features/auth/presentation/blocs/institutional_email_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../blocs/institutional_email_event.dart';
import '../blocs/institutional_email_state.dart';

class EnterInstitutionalEmailPage extends StatelessWidget {
  const EnterInstitutionalEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InstitutionalEmailBloc(
        authRepository: di.sl<AuthRepository>(),
        userRepository: di.sl<UserRepository>(),
      ),
      child: const EnterInstitutionalEmailView(),
    );
  }
}

class EnterInstitutionalEmailView extends StatelessWidget {
  const EnterInstitutionalEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InstitutionalEmailBloc, InstitutionalEmailState>(
      listener: (context, state) {
        if (state.isEmailSent) {
          Navigator.pushNamed(context, ScreensRoutes.enterVerificationCode);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 16.0,
                ),
                child: const Text(
                  'Introduce tu correo institucional',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),

              // Subtitle
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 40.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: const Text(
                  'Te enviaremos un codigo para verificar tu correo.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: BlocBuilder<
                      InstitutionalEmailBloc,
                      InstitutionalEmailState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultRoundedInputField(
                            value: state.email,
                            onValueChange: (value) {
                              context.read<InstitutionalEmailBloc>().add(
                                EmailInputChanged(value),
                              );
                            },
                            placeholder: 'example@university.upc.edu',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          // Bottom section
                          Column(
                            children: [
                              // Loading indicator
                              if (state.isLoading)
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),

                              const SizedBox(height: 20),

                              // Send button
                              if (state.isButtonAvailable && !state.isLoading)
                                DefaultRoundedTextButton(
                                  text: 'Enviar codigo',
                                  onPressed: () {
                                    context.read<InstitutionalEmailBloc>().add(
                                      const SendVerificationEmailRequested(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}