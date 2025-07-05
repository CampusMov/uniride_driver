import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/navigation/screens_routes.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class RegisterProfileFullNamePage extends StatelessWidget {
  const RegisterProfileFullNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: const _RegisterProfileFullNameContent(),
    );
  }
}

class _RegisterProfileFullNameContent extends StatelessWidget {
  const _RegisterProfileFullNameContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<RegisterProfileBloc, RegisterProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                // Header Text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 16.0,
                  ),
                  child: const Text(
                    '¿Cuál es tu nombre?',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Subtitle Text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: const Text(
                    'Háganoslo saber para dirigirnos a usted correctamente.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Input Fields Section
                        Column(
                          children: [
                            // First Name Field
                            DefaultRoundedInputField(
                              value: state.profileState.firstName,
                              onValueChange: (value) {
                                context.read<RegisterProfileBloc>()
                                    .add(FirstNameChanged(value));
                              },
                              placeholder: 'Ingresa tus nombres',
                              keyboardType: TextInputType.text,
                            ),

                            // Divider (transparent space)
                            const SizedBox(height: 16.0),

                            // Last Name Field
                            DefaultRoundedInputField(
                              value: state.profileState.lastName,
                              onValueChange: (value) {
                                context.read<RegisterProfileBloc>()
                                    .add(LastNameChanged(value));
                              },
                              placeholder: 'Ingresa tus apellidos',
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),

                        // Next Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: DefaultRoundedTextButton(
                            text: 'Siguiente',
                            enabled: state.isFullNameRegisterValid,
                            enabledRightIcon: true,
                            onPressed: () {
                              // Update next step in BLoC
                              context.read<RegisterProfileBloc>()
                                  .add(const NextStepChanged(0));

                              // Navigate to next screen
                              Navigator.pushNamed(
                                context,
                                ScreensRoutes.registerProfileListSections,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}