import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/navigation/screens_routes.dart';
import '../../../../core/utils/resource.dart';
import '../../../shared/utils/model/item_model.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class RegisterProfileListSectionsPage extends StatelessWidget {
  const RegisterProfileListSectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: BlocListener<RegisterProfileBloc, RegisterProfileState>(
        listener: (context, state) {
          if(state.isRegisteredProfileSuccess) {
            Navigator.of(context).pushReplacementNamed(ScreensRoutes.searchCarpool);
          }
        },
        child: const _RegisterProfileListSectionsContent(),
      ),
    );
  }
}

class _RegisterProfileListSectionsContent extends StatelessWidget {
  const _RegisterProfileListSectionsContent();

  @override
  Widget build(BuildContext context) {
    final items = [
      NavigationItem(
        title: 'Información personal',
        route: ScreensRoutes.registerProfilePersonalInformation,
        icon: Icons.chevron_right,
      ),
      NavigationItem(
        title: 'Información de contacto',
        route: ScreensRoutes.registerProfileContactInformation,
        icon: Icons.chevron_right,
      ),
      NavigationItem(
        title: 'Información académica',
        route: ScreensRoutes.registerProfileAcademicInformation,
        icon: Icons.chevron_right,
      ),
      NavigationItem(
        title: 'Información del vehículo',
        route: ScreensRoutes.registerProfileVehicleInformation,
        icon: Icons.chevron_right,
      ),
      NavigationItem(
        title: 'Términos y condiciones',
        route: ScreensRoutes.registerProfileAcceptTermsAndConditions,
        icon: Icons.chevron_right,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<RegisterProfileBloc, RegisterProfileState>(
          listener: (context, state) {
            // Navigate to matching when profile is saved successfully
            if (state.registerProfileResponse is Success) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                ScreensRoutes.searchCarpool,
                    (route) => false,
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header and List Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Text
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            'Bienvenido, ${state.profileState.firstName}',
                            style: const TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Subtitle Text
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            bottom: 20.0,
                          ),
                          child: const Text(
                            'Esto es lo que debe hacer para configurar su cuenta.',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Navigation Items List
                        Expanded(
                          child: ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (context, index) => Container(
                              height: 1.0,
                              color: const Color(0xFF2E2E2E),
                            ),
                            itemBuilder: (context, index) {
                              return RegisterProfileItemSection(
                                item: items[index],
                                currentPosition: index,
                                nextRecommendedPosition: state.nextRecommendedStep,
                                onTap: () {
                                  Navigator.pushNamed(context, items[index].route);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Section - Loading and Button
                Column(
                  children: [
                    // Loading Indicator
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                        ),
                      ),

                    const SizedBox(height: 20.0),

                    // Start Button
                    if (state.isRegisterProfileValid && !state.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: DefaultRoundedTextButton(
                            text: '¡Comenzar!',
                            onPressed: () {
                              context.read<RegisterProfileBloc>()
                                  .add(const SaveProfile());
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RegisterProfileItemSection extends StatelessWidget {
  final NavigationItem item;
  final int currentPosition;
  final int nextRecommendedPosition;
  final VoidCallback onTap;

  const RegisterProfileItemSection({
    super.key,
    required this.item,
    required this.currentPosition,
    required this.nextRecommendedPosition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNextRecommended = currentPosition == nextRecommendedPosition;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 60.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side - Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  if (isNextRecommended) ...[
                    const SizedBox(height: 5.0),
                    const Text(
                      'Siguiente paso recomendado',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA2B9E4),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Right side - Arrow icon
            Icon(
              item.icon,
              color: Colors.white,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}