import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/navigation/screens_routes.dart';
import '../../../shared/utils/widgets/default_rounded_date_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_drop_down_field.dart';
import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../../domain/entities/enum_gender.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class RegisterProfilePersonalInfoPage extends StatelessWidget {
  const RegisterProfilePersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: const _RegisterProfilePersonalInfoContent(),
    );
  }
}

class _RegisterProfilePersonalInfoContent extends StatefulWidget {
  const _RegisterProfilePersonalInfoContent();

  @override
  State<_RegisterProfilePersonalInfoContent> createState() =>
      _RegisterProfilePersonalInfoContentState();
}

class _RegisterProfilePersonalInfoContentState
    extends State<_RegisterProfilePersonalInfoContent> {

  final ImagePicker _imagePicker = ImagePicker();
  DateTime? _selectedDateMillis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<RegisterProfileBloc, RegisterProfileState>(
          builder: (context, state) {
            // Sync selected date with state
            if (state.profileState.birthDate != null && _selectedDateMillis == null) {
              _selectedDateMillis = state.profileState.birthDate;
            }

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
                              'Información personal',
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
                              'Esta es la información que quieres que las personas usen cuando se refieran a ti.',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Profile Picture Section
                          SizedBox(
                            width: 110.0,
                            height: 110.0,
                            child: Stack(
                              children: [
                                // Profile Picture Container
                                Container(
                                  width: 110.0,
                                  height: 110.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: state.profileState.profilePictureUrl.isNotEmpty
                                        ? Image.network(
                                      state.profileState.profilePictureUrl,
                                      width: 110.0,
                                      height: 110.0,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return _buildDefaultProfileIcon();
                                      },
                                    )
                                        : _buildDefaultProfileIcon(),
                                  ),
                                ),

                                // Edit Button
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF292929),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () => _pickImage(context),
                                      padding: const EdgeInsets.all(8.0),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25.0),

                          // First Name Field
                          const Text(
                            'Nombres',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'Ingresa tus nombres',
                            value: state.profileState.firstName,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(FirstNameChanged(value));
                            },
                          ),

                          const SizedBox(height: 15.0),

                          // Last Name Field
                          const Text(
                            'Apellidos',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedInputField(
                            placeholder: 'Ingresa tus apellidos',
                            value: state.profileState.lastName,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(LastNameChanged(value));
                            },
                          ),

                          const SizedBox(height: 15.0),

                          // Birth Date Field
                          const Text(
                            'Fecha de nacimiento',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedDateInputField(
                            selectedDate: _selectedDateMillis,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDateMillis = date;
                              });
                              if (date != null) {
                                context.read<RegisterProfileBloc>()
                                    .add(BirthDateChanged(date));
                              }
                            },
                            placeholder: 'Selecciona fecha',
                          ),

                          const SizedBox(height: 15.0),

                          // Gender Field
                          const Text(
                            'Género',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DefaultRoundedDropdownField<EGender>(
                            selectedOption: state.profileState.gender,
                            options: const ['MALE', 'FEMALE'],
                            placeholder: 'Selecciona tu género',
                            optionLabels: const {
                              EGender.male: 'Masculino',
                              EGender.female: 'Femenino',
                            },
                            onOptionSelected: (selectedString) {
                              final gender = selectedString == 'MALE'
                                  ? EGender.male
                                  : EGender.female;
                              context.read<RegisterProfileBloc>()
                                  .add(GenderChanged(gender));
                            },
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
                      enabled: state.isPersonalInformationRegisterValid,
                      onPressed: () {
                        // Update next step in BLoC
                        context.read<RegisterProfileBloc>()
                            .add(const NextStepChanged(1));

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

  Widget _buildDefaultProfileIcon() {
    return Container(
      width: 110.0,
      height: 110.0,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 60.0,
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null && context.mounted) {
        // Convert XFile to Uri for the BLoC
        final uri = Uri.file(image.path);
        context.read<RegisterProfileBloc>()
            .add(UploadProfileImage(uri));
      }
    } catch (e) {
      // Handle image picker error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
