// lib/features/home/presentation/widgets/class_schedule_selection_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_text_field.dart';
import 'package:uniride_driver/features/profile/domain/entities/class_schedule.dart';

import '../bloc/carpool/create_carpool_bloc.dart';
import '../bloc/carpool/create_carpool_event.dart';
import '../bloc/carpool/create_carpool_state.dart';

class ClassScheduleSelectionDialog extends StatefulWidget {
  const ClassScheduleSelectionDialog({super.key});

  @override
  State<ClassScheduleSelectionDialog> createState() => _ClassScheduleSelectionDialogState();
}

class _ClassScheduleSelectionDialogState extends State<ClassScheduleSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCarpoolBloc, CreateCarpoolState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: ColorPaletter.background,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seleccionar clase',
                        style: TextStylePaletter.title,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CreateCarpoolBloc>()
                              .add(const CloseDialogToSelectClassSchedule());
                        },
                        icon: Icon(
                          Icons.close,
                          color: ColorPaletter.textPrimary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: ColorPaletter.inputField,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomTextField(
                    icon: Icon(Icons.search, color: ColorPaletter.textPrimary),
                    editingController: _searchController,
                    hintText: 'Buscar por curso, ubicación o día',
                    onChanged: (value) {
                      context.read<CreateCarpoolBloc>()
                          .add(ClassScheduleSearchChanged(value));
                    },
                  ),
                ),

                const SizedBox(height: 16.0),

                // Content
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CreateCarpoolState state) {
    if (state.isLoadingClassSchedules) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: ColorPaletter.textPrimary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Cargando horarios...',
              style: TextStylePaletter.body,
            ),
          ],
        ),
      );
    }

    if (state.filteredClassSchedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64.0,
              color: ColorPaletter.textSecondary,
            ),
            const SizedBox(height: 16.0),
            Text(
              state.allClassSchedules.isEmpty
                  ? 'No tienes horarios de clases registrados'
                  : 'No se encontraron horarios con esa búsqueda',
              style: TextStylePaletter.body,
              textAlign: TextAlign.center,
            ),
            if (state.allClassSchedules.isEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                'Registra tus horarios en tu perfil',
                style: TextStylePaletter.spam,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: state.filteredClassSchedules.length,
      separatorBuilder: (context, index) => Divider(
        color: ColorPaletter.inputField,
        height: 1.0,
      ),
      itemBuilder: (context, index) {
        final schedule = state.filteredClassSchedules[index];
        return ClassScheduleListItem(
          schedule: schedule,
          onTap: () {
            context.read<CreateCarpoolBloc>()
                .add(ClassScheduleSelected(schedule));
          },
        );
      },
    );
  }
}

class ClassScheduleListItem extends StatelessWidget {
  final ClassSchedule schedule;
  final VoidCallback onTap;

  const ClassScheduleListItem({
    super.key,
    required this.schedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Course Icon
            Container(
              decoration: BoxDecoration(
                color: ColorPaletter.inputField,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.school,
                color: ColorPaletter.textPrimary,
                size: 20.0,
              ),
            ),

            const SizedBox(width: 12.0),

            // Schedule Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Name
                  Text(
                    schedule.courseName,
                    style: TextStylePaletter.textOptions,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4.0),

                  // Time and Day
                  Text(
                    schedule.scheduleTime(),
                    style: TextStylePaletter.subTextOptions.copyWith(
                      color: ColorPaletter.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 2.0),

                  // Location
                  Text(
                    schedule.locationName,
                    style: TextStylePaletter.spam,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.chevron_right,
              color: ColorPaletter.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}