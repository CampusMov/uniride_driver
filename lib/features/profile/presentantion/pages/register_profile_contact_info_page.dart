import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/navigation/screens_routes.dart';
import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class RegisterProfileContactInfoPage extends StatelessWidget {
  const RegisterProfileContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: const _RegisterProfileContactInfoContent(),
    );
  }
}

class _RegisterProfileContactInfoContent extends StatelessWidget {
  const _RegisterProfileContactInfoContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<RegisterProfileBloc, RegisterProfileState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            width: 31.0,
                            height: 31.0,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),

                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: const Text(
                              'Información de contacto',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Subtitle
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
                            child: const Text(
                              'Esta es la información que quieres por donde nos contactemos contigo.',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25.0),

                          // Institutional Email Field
                          const Text(
                            'Correo institucional',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'Ingresa tu correo institucional',
                            value: state.profileState.institutionalEmailAddress,
                            onValueChange: (value) {
                              // Disabled field - no action needed
                            },
                            enabled: false,
                          ),

                          const SizedBox(height: 15.0),

                          // Personal Email Field
                          const Text(
                            'Correo personal',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'example@gmail.com',
                            value: state.profileState.personalEmailAddress,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(PersonalEmailChanged(value));
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 15.0),

                          // Phone Number Field
                          const Text(
                            'Número de celular',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),

                          // Phone Number with Country Code
                          Row(
                            children: [
                              // Country Code Field
                              SizedBox(
                                width: 80.0,
                                child: DefaultRoundedInputField(
                                  placeholder: '+51',
                                  value: state.profileState.countryCode,
                                  onValueChange: (value) {
                                    // Country code is usually fixed, but can be made editable if needed
                                  },
                                  enabled: false,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),

                              const SizedBox(width: 8.0),

                              // Phone Number Field
                              Expanded(
                                child: DefaultRoundedInputField(
                                  placeholder: '999999999',
                                  value: state.profileState.phoneNumber,
                                  onValueChange: (value) {
                                    context.read<RegisterProfileBloc>()
                                        .add(PhoneNumberChanged(value));
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: DefaultRoundedTextButton(
                      text: 'Guardar',
                      enabled: state.isContactInformationRegisterValid,
                      onPressed: () {
                        // Update next step in BLoC
                        context.read<RegisterProfileBloc>()
                            .add(const NextStepChanged(2));

                        // Navigate back to list
                        Navigator.pushNamed(
                          context,
                          ScreensRoutes.registerProfileListSections,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\d{9}$');
    return phone.isNotEmpty && phoneRegex.hasMatch(phone);
  }
}