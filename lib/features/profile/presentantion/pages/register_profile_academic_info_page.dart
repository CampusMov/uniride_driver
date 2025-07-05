import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/navigation/screens_routes.dart';
import '../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../../domain/entities/class_schedule.dart';
import '../bloc/register_profile_bloc.dart';
import '../bloc/register_profile_event.dart';
import '../bloc/states/register_profile_state.dart';
import '../components/class_schedule_dialog.dart';

class RegisterProfileAcademicInfoPage extends StatelessWidget {
  const RegisterProfileAcademicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<RegisterProfileBloc>(),
      child: const _RegisterProfileAcademicInfoContent(),
    );
  }
}

class _RegisterProfileAcademicInfoContent extends StatelessWidget {
  const _RegisterProfileAcademicInfoContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<RegisterProfileBloc, RegisterProfileState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Main Content
                Padding(
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
                                  'Información académica',
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
                                  'Esta es la información que quieres que usemos para brindarte los mejores carpool que se adapten a tus horarios.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // University Field
                              const Text(
                                'Universidad',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              DefaultRoundedInputField(
                                placeholder: 'Ingresa tu universidad (UPC)',
                                value: state.profileState.university,
                                onValueChange: (value) {
                                  context.read<RegisterProfileBloc>()
                                      .add(UniversityChanged(value));
                                },
                              ),

                              const SizedBox(height: 15.0),

                              // Faculty Field
                              const Text(
                                'Facultad',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              DefaultRoundedInputField(
                                placeholder: 'Ingresa tu facultad (Ingeniería)',
                                value: state.profileState.faculty,
                                onValueChange: (value) {
                                  context.read<RegisterProfileBloc>()
                                      .add(FacultyChanged(value));
                                },
                              ),

                              const SizedBox(height: 15.0),

                              // Academic Program Field
                              const Text(
                                'Carrera',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              DefaultRoundedInputField(
                                placeholder: 'Ingresa tu carrera (Ingeniería de Sistemas)',
                                value: state.profileState.academicProgram,
                                onValueChange: (value) {
                                  context.read<RegisterProfileBloc>()
                                      .add(AcademicProgramChanged(value));
                                },
                              ),

                              const SizedBox(height: 15.0),

                              // Semester Field
                              const Text(
                                'Ciclo académico',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              DefaultRoundedInputField(
                                placeholder: 'Ingresa tu ciclo de ingreso (2023-2)',
                                value: state.profileState.semester,
                                onValueChange: (value) {
                                  context.read<RegisterProfileBloc>()
                                      .add(SemesterChanged(value));
                                },
                              ),

                              const SizedBox(height: 20.0),

                              // Schedules Section Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Horarios',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<RegisterProfileBloc>()
                                          .add(const OpenDialogToAddNewSchedule());
                                    },
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15.0),

                              // Schedules List
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.profileState.classSchedules.length,
                                separatorBuilder: (context, index) => Container(
                                  height: 1.0,
                                  color: const Color(0xFF3F4042),
                                ),
                                itemBuilder: (context, index) {
                                  final schedule = state.profileState.classSchedules[index];
                                  return ClassScheduleItemView(
                                    schedule: schedule,
                                    onTap: () {
                                      context.read<RegisterProfileBloc>()
                                          .add(OpenDialogToEditSchedule(schedule.id));
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Save Button
                      if (state.isAcademicInformationRegisterValid)
                        SizedBox(
                          width: double.infinity,
                          child: DefaultRoundedTextButton(
                            text: 'Guardar',
                            onPressed: () {
                              context.read<RegisterProfileBloc>()
                                  .add(const NextStepChanged(3));
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

                // Schedule Dialog Overlay
                if (state.isScheduleDialogOpen)
                  ClassScheduleDialogView(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ClassScheduleItemView extends StatelessWidget {
  final ClassSchedule schedule;
  final VoidCallback onTap;

  const ClassScheduleItemView({
    super.key,
    required this.schedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat.Hm(); // HH:mm format

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Calendar Icon
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF292929),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 20.0,
              ),
            ),

            const SizedBox(width: 12.0),

            // Schedule Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.courseName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        '${_formatTime(schedule.startedAt)} – ${_formatTime(schedule.endedAt)}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        schedule.selectedDay.showDay(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dateTime);
  }
}