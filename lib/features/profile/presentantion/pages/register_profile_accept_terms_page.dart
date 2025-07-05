import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/navigation/screens_routes.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class RegisterProfileAcceptTermsPage extends StatelessWidget {
  const RegisterProfileAcceptTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: const _RegisterProfileAcceptTermsContent(),
    );
  }
}

class _RegisterProfileAcceptTermsContent extends StatelessWidget {
  const _RegisterProfileAcceptTermsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<RegisterProfileBloc, RegisterProfileState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Main Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                          // Header Section with Icon and Title
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              children: [
                                // Terms Icon
                                Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.description_outlined,
                                    color: Colors.black,
                                    size: 60.0,
                                  ),
                                ),

                                const SizedBox(width: 12.0),

                                // Title Text
                                const Expanded(
                                  child: Text(
                                    'Acepta los términos de UniRide y revisa el aviso de privacidad',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w800,
                                      height: 1.6, // lineHeight equivalent
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Description Text
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Al seleccionar "Acepto" a continuación, he revisado y acepto las Condiciones de uso de y acepto el Aviso de privacidad. Soy mayor de 18 años.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Divider
                        Container(
                          height: 2.0,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.white.withOpacity(0.2),
                        ),

                        // Checkbox Row
                        GestureDetector(
                          onTap: () {
                            context.read<RegisterProfileBloc>()
                                .add(TermsAcceptedChanged(!state.isTermsAccepted));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Estoy de acuerdo.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Checkbox(
                                  value: state.isTermsAccepted,
                                  onChanged: (value) {
                                    context.read<RegisterProfileBloc>()
                                        .add(TermsAcceptedChanged(value ?? false));
                                  },
                                  checkColor: Colors.black,
                                  fillColor: WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return Colors.white;
                                      }
                                      return Colors.transparent;
                                    },
                                  ),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Next Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: DefaultRoundedTextButton(
                            text: 'Siguiente',
                            enabled: state.isTermsAcceptedValid,
                            enabledRightIcon: true,
                            onPressed: () {
                              // Update next step to -1 (completed all)
                              context.read<RegisterProfileBloc>()
                                  .add(const NextStepChanged(-1));

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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}