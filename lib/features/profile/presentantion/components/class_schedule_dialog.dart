import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../../../shared/utils/widgets/time_picker_input_field_24h.dart';
import '../../domain/entities/enum_day.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';

class ClassScheduleDialogView extends StatefulWidget {
  const ClassScheduleDialogView({super.key});

  @override
  State<ClassScheduleDialogView> createState() => _ClassScheduleDialogViewState();
}

class _ClassScheduleDialogViewState extends State<ClassScheduleDialogView> {
  String _locationQuery = '';
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterProfileBloc, RegisterProfileState>(
      builder: (context, state) {
        final currentSchedule = state.currentClassScheduleState;
        final isValid = state.isCurrentClassScheduleValid;
        final locationPredictions = state.locationPredictions;

        // Sync location query with selected location
        if (currentSchedule.selectedLocation != null &&
            _locationQuery.isEmpty) {
          _locationQuery = currentSchedule.selectedLocation!.address;
          _locationController.text = _locationQuery;
        }

        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 21.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40.0),
                        Expanded(
                          child: Text(
                            currentSchedule.isEditing
                                ? 'Actualizar horario'
                                : 'Agregar horario',
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF3F4042),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              context.read<RegisterProfileBloc>()
                                  .add(const CloseScheduleDialog());
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course Name
                          const Text(
                            'Nombre del curso',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          DefaultRoundedInputField(
                            value: currentSchedule.courseName,
                            onValueChange: (value) {
                              context.read<RegisterProfileBloc>()
                                  .add(ScheduleCourseNameChanged(value));
                            },
                            placeholder: 'Matemática básica',
                          ),

                          const SizedBox(height: 16.0),

                          // Start Time
                          const Text(
                            'Hora de inicio',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          TimePickerInputField24H(
                            time: currentSchedule.startedAt,
                            onTimeChange: (time) {
                              context.read<RegisterProfileBloc>()
                                  .add(ScheduleStartTimeChanged(time));
                            },
                            placeholder: 'Selecciona hora de inicio',
                          ),

                          const SizedBox(height: 16.0),

                          // End Time
                          const Text(
                            'Hora de salida',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          TimePickerInputField24H(
                            time: currentSchedule.endedAt,
                            onTimeChange: (time) {
                              context.read<RegisterProfileBloc>()
                                  .add(ScheduleEndTimeChanged(time));
                            },
                            placeholder: 'Selecciona hora de salida',
                          ),

                          const SizedBox(height: 16.0),

                          // Day Selection
                          const Text(
                            'Día de la semana',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: EDay.values.map((day) {
                              final isSelected = currentSchedule.selectedDay ==
                                  day;
                              return GestureDetector(
                                onTap: () {
                                  context.read<RegisterProfileBloc>()
                                      .add(ScheduleDaySelected(day));
                                },
                                child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF3F4042)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.showDay().substring(0, 1),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16.0),

                          // Location
                          const Text(
                            'Universidad ubicación',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          DefaultRoundedInputField(
                            value: _locationQuery,
                            onValueChange: (value) {
                              setState(() {
                                _locationQuery = value;
                              });
                              _locationController.text = value;

                              if (value.isEmpty) {
                                context.read<RegisterProfileBloc>()
                                    .add(const ScheduleLocationCleared());
                              } else {
                                context.read<RegisterProfileBloc>()
                                    .add(ScheduleLocationQueryChanged(value));
                              }
                            },
                            placeholder: 'Surco, Primavera 2653',
                          ),

                          // Location Predictions
                          if (currentSchedule.selectedLocation == null &&
                              locationPredictions.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              height: 200.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2D2D),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                itemCount: locationPredictions.length,
                                separatorBuilder: (context, index) =>
                                const Divider(
                                  color: Colors.white24,
                                  height: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  final prediction = locationPredictions[index];
                                  return InkWell(
                                    onTap: () {
                                      context.read<RegisterProfileBloc>()
                                          .add(ScheduleLocationSelected(
                                          prediction));
                                      setState(() {
                                        _locationQuery = prediction.description;
                                      });
                                      _locationController.text = _locationQuery;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.white70,
                                            size: 20.0,
                                          ),
                                          const SizedBox(width: 12.0),
                                          Expanded(
                                            child: Text(
                                              prediction.description,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          // Selected Location Display
                          if (currentSchedule.selectedLocation != null)
                            Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2D2D),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        const Text(
                                          'Ubicación seleccionada:',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          currentSchedule.selectedLocation!
                                              .address,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<RegisterProfileBloc>()
                                          .add(const ScheduleLocationCleared());
                                      setState(() {
                                        _locationQuery = '';
                                      });
                                      _locationController.clear();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white70,
                                      size: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Buttons
                  if (isValid)
                    Column(
                      children: [
                        if (currentSchedule.isEditing) ...[
                          SizedBox(
                            width: double.infinity,
                            child: DefaultRoundedTextButton(
                              text: 'Actualizar',
                              onPressed: () {
                                context.read<RegisterProfileBloc>()
                                    .add(const EditExistingClassSchedule());
                              },
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          GestureDetector(
                            onTap: () {
                              context.read<RegisterProfileBloc>()
                                  .add(const DeleteSchedule());
                            },
                            child: const Text(
                              'Eliminar horario',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ] else
                          SizedBox(
                            width: double.infinity,
                            child: DefaultRoundedTextButton(
                              text: 'Agregar',
                              onPressed: () {
                                context.read<RegisterProfileBloc>()
                                    .add(const AddClassScheduleToProfile());
                              },
                            ),
                          ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}