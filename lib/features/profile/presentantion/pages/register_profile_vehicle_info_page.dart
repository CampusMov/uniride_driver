import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/navigation/screens_routes.dart';
import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class RegisterProfileVehicleInfoPage extends StatelessWidget {
  const RegisterProfileVehicleInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: const _RegisterProfileVehicleInfoContent(),
    );
  }
}

class _RegisterProfileVehicleInfoContent extends StatelessWidget {
  const _RegisterProfileVehicleInfoContent();

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

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
                              'Información del vehículo',
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
                              'Esta es la información que quieres que usemos para que los pasajeros sepan en qué auto van a llegar.',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25.0),

                          // License Plate Field
                          const Text(
                            'Placa de licencia',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'AAA-BBB-CCC',
                            value: state.vehicleLicensePlate,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(VehicleLicensePlateChanged(value.toUpperCase()));
                            },
                          ),

                          const SizedBox(height: 15.0),

                          // Vehicle Brand Field
                          const Text(
                            'Marca del vehículo',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'Toyota',
                            value: state.vehicleBrand,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(VehicleBrandChanged(value));
                            },
                          ),

                          const SizedBox(height: 15.0),

                          // Vehicle Model Field
                          const Text(
                            'Modelo',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'Avanza',
                            value: state.vehicleModel,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(VehicleModelChanged(value));
                            },
                          ),

                          const SizedBox(height: 15.0),

                          // Manufacturing Year Field
                          const Text(
                            'Año del fabricación',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: '2020',
                            value: state.vehicleYear.toString(),
                            onValueChange: (value) {
                              final year = int.tryParse(value);
                              if (year != null && year >= 1900 && year <= currentYear + 1) {
                                context.read<RegisterProfileBloc>()
                                    .add(VehicleYearChanged(year));
                              }
                            },
                            keyboardType: TextInputType.number,
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
                      enabled: state.isVehicleInformationRegisterValid,
                      onPressed: () {
                        // Update next step in BLoC
                        context.read<RegisterProfileBloc>()
                            .add(const NextStepChanged(4));

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
}