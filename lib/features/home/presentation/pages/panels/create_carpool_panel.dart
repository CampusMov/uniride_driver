import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/events/app_event_bus.dart';
import '../../../../../core/events/app_events.dart';
import '../../../../../core/utils/resource.dart';
import '../../../../shared/utils/widgets/default_rounded_input_field.dart';
import '../../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../../../domain/entities/routing-matching/enum_trip_state.dart';
import '../../bloc/carpool/create_carpool_bloc.dart';
import '../../bloc/carpool/create_carpool_event.dart';
import '../../bloc/carpool/create_carpool_state.dart';

class CreateCarpoolPanel extends StatelessWidget {
  const CreateCarpoolPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCarpoolBloc, CreateCarpoolState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Field to select origin location
              _buildOriginLocationField(context, state),

              const SizedBox(height: 16),

              // Field to select class schedule
              _buildClassScheduleField(context, state),

              const SizedBox(height: 16),

              // Selector for number of passengers
              _buildPassengersSelector(context, state),

              const SizedBox(height: 16),

              // Selector for matching radius
              _buildRadiusSelector(context, state),

              const SizedBox(height: 16),

              // Button to create carpool
              _buildCreateButton(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOriginLocationField(BuildContext context, CreateCarpoolState state) {
    if (state.originLocation == null) {
      return DefaultRoundedInputField(
        value: '',
        onValueChange: (_) {},
        placeholder: 'Seleccionar punto de partida',
        enabled: false,
        enableLeadingIcon: true,
        leadingIcon: Icons.my_location,
        onTap: () {
          context.read<CreateCarpoolBloc>().add(const OpenDialogToSelectOriginLocation());
        },
      );
    } else {
      return GestureDetector(
        onTap: () {
          context.read<CreateCarpoolBloc>().add(const OpenDialogToSelectOriginLocation());
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  state.originLocation!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Partida',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildClassScheduleField(BuildContext context, CreateCarpoolState state) {
    if (state.classSchedule == null) {
      return DefaultRoundedInputField(
        value: '',
        onValueChange: (_) {},
        placeholder: 'Seleccionar horario de clase',
        enabled: false,
        enableLeadingIcon: true,
        leadingIcon: Icons.schedule,
        onTap: () {
          context.read<CreateCarpoolBloc>().add(const OpenDialogToSelectClassSchedule());
        },
      );
    } else {
      return GestureDetector(
        onTap: () {
          context.read<CreateCarpoolBloc>().add(const OpenDialogToSelectClassSchedule());
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.classSchedule!.courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${state.classSchedule!.startedAt.format(context)} - ${state.classSchedule!.endedAt.format(context)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB3B3B3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Llegada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPassengersSelector(BuildContext context, CreateCarpoolState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Cantidad asientos disponibles:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        Row(
          children: [
            IconButton(
              onPressed: state.maxPassengers > 1
                  ? () => context.read<CreateCarpoolBloc>().add(const DecreaseMaxPassengers())
                  : null,
              icon: Icon(
                Icons.remove_circle_outline,
                color: state.maxPassengers > 1 ? Colors.white : Colors.grey,
                size: 30,
              ),
            ),

            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Text(
                  state.maxPassengers.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            IconButton(
              onPressed: state.maxPassengers < 4
                  ? () => context.read<CreateCarpoolBloc>().add(const IncreaseMaxPassengers())
                  : null,
              icon: Icon(
                Icons.add_circle_outline,
                color: state.maxPassengers < 4 ? Colors.white : Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadiusSelector(BuildContext context, CreateCarpoolState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Radio de emparejamiento:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        Row(
          children: [
            IconButton(
              onPressed: state.radius > 50
                  ? () => context.read<CreateCarpoolBloc>().add(const DecreaseRadius())
                  : null,
              icon: Icon(
                Icons.remove_circle_outline,
                color: state.radius > 50 ? Colors.white : Colors.grey,
                size: 30,
              ),
            ),

            SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: Text(
                  '${state.radius}m',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            IconButton(
              onPressed: state.radius < 100
                  ? () => context.read<CreateCarpoolBloc>().add(const IncreaseRadius())
                  : null,
              icon: Icon(
                Icons.add_circle_outline,
                color: state.radius < 100 ? Colors.white : Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, CreateCarpoolState state) {
    return DefaultRoundedTextButton(
      text: 'Crear carpool',
      loadingText: 'Creando carpool',
      isLoading: state.isLoading,
      enabled: state.isValidCarpool,
      onPressed: () => context.read<CreateCarpoolBloc>().add(const SaveCarpool()),
      backgroundColor: const Color(0xFFC4C4C4),
      textColor: Colors.black,
      disabledTextColor: Colors.black,
    );
  }
}


class CarpoolCreationResultDialog extends StatelessWidget {
  const CarpoolCreationResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCarpoolBloc, CreateCarpoolState>(
      listener: (context, state) {
        if (state.carpoolCreationResult != null) {
          // Show the result of the carpool creation
          if (state.carpoolCreationResult is Success) {
            final success = state.carpoolCreationResult as Success;
            final carpool = success.data;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Carpool creado exitosamente'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );

            // Emit an event to update the trip state
            AppEventBus().emit(const TripStateChangeRequested(TripState.waitingToStartCarpool));

            // Emit an event to notify that the carpool was created successfully
            AppEventBus().emit(CarpoolCreatedSuccessfully(carpool.id));

          } else if (state.carpoolCreationResult is Failure) {
            final failure = state.carpoolCreationResult as Failure;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Error: ${failure.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }

          // Clear the result after showing it
          context.read<CreateCarpoolBloc>().add(const ClearCarpoolCreationResult());
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}