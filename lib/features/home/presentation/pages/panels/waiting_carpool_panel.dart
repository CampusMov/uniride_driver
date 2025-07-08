import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/widgets/default_rounded_text_button.dart';
import '../../bloc/carpool/waiting_carpool_bloc.dart';
import '../../bloc/carpool/waiting_carpool_event.dart';
import '../../bloc/carpool/waiting_carpool_state.dart';

class WaitingCarpoolPanel extends StatelessWidget {
  const WaitingCarpoolPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaitingCarpoolBloc, WaitingCarpoolState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }

        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${state.successMessage}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              _buildHeader(state),

              const SizedBox(height: 20),

              if (state.isLoadingCarpool)
                _buildLoadingSection('Cargando información del carpool...')
              else if (state.hasCarpool) ...[

                // Carpool info
                _buildCarpoolInfo(context, state),

                const SizedBox(height: 16),

                // Route info
                _buildRouteInfo(context, state),

                const SizedBox(height: 20),

                // Action buttons
                _buildActionButtons(context, state),
              ] else
                _buildErrorSection(context, 'No se pudo cargar la información del carpool'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(WaitingCarpoolState state) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_car,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Carpool Creado',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Esperando a iniciar viaje',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFB3B3B3),
                ),
              ),
            ],
          ),
        ),

        if (state.isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildCarpoolInfo(BuildContext context, WaitingCarpoolState state) {
    final carpool = state.carpool!;

    return Column(
      children: [

        // Origin
        _buildLocationRow(
          icon: Icons.my_location,
          iconColor: const Color(0xFF4CAF50),
          title: carpool.origin.name,
          subtitle: 'Punto de partida',
          tag: 'Origen',
          tagColor: const Color(0xFF2E7D32),
        ),

        const SizedBox(height: 12),

        // Destination
        _buildLocationRow(
          icon: Icons.school,
          iconColor: const Color(0xFF2196F3),
          title: carpool.destination.name,
          subtitle: '${carpool.startedClassTime.format(context)} - ${carpool.endedClassTime.format(context)}',
          tag: 'Destino',
          tagColor: const Color(0xFF1976D2),
        ),

        const SizedBox(height: 16),

        // Additional info
        _buildInfoRow('Asientos disponibles', '${carpool.maxPassengers}'),
        _buildInfoRow('Radio de emparejamiento', '${carpool.radius}m'),
        _buildInfoRow('Día de clase', carpool.classDay),
      ],
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
  }) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
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
                title,
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
                subtitle,
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
            color: tagColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFB3B3B3),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(BuildContext context, WaitingCarpoolState state) {
    if (state.isLoadingRoute) {
      return _buildLoadingSection('Generando ruta...');
    }

    if (!state.hasRoute) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.route,
              color: Color(0xFFFF9800),
              size: 24,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Ruta no disponible',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<WaitingCarpoolBloc>().add(const GenerateRoute());
              },
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  color: Color(0xFF2196F3),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final route = state.route!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.route,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ruta Generada',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Lista',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRouteDetail(
                'Distancia',
                '${route.totalDistance.toStringAsFixed(1)} km',
                Icons.straighten,
              ),
              _buildRouteDetail(
                'Duración',
                '${route.totalDuration.toInt()} min',
                Icons.access_time,
              ),
              _buildRouteDetail(
                'Puntos',
                '${state.routeCoordinates!.length}',
                Icons.place,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFB3B3B3),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB3B3B3),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WaitingCarpoolState state) {
    return Column(
      children: [

        // Start Carpool Button
        DefaultRoundedTextButton(
          text: 'Iniciar Carpool',
          loadingText: 'Iniciando...',
          isLoading: state.isStartingCarpool,
          enabled: state.hasRoute && !state.isLoading,
          onPressed: () => context.read<WaitingCarpoolBloc>().add(const StartCarpool()),
          backgroundColor: const Color(0xFF4CAF50),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
        ),

        const SizedBox(height: 12),

        // Cancel Carpool Button
        DefaultRoundedTextButton(
          text: 'Cancelar Carpool',
          loadingText: 'Cancelando...',
          isLoading: state.isCancellingCarpool,
          enabled: !state.isLoading,
          onPressed: () => _showCancelDialog(context),
          backgroundColor: const Color(0xFFE53935),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildLoadingSection(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFE53935),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFE53935),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          DefaultRoundedTextButton(
            text: 'Reintentar',
            onPressed: () => context.read<WaitingCarpoolBloc>().add(const RefreshCarpoolData()),
            backgroundColor: const Color(0xFF2196F3),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF424242),
          title: const Text(
            '¿Cancelar Carpool?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Esta acción no se puede deshacer. ¿Estás seguro de que quieres cancelar este carpool?',
            style: TextStyle(color: Color(0xFFB3B3B3)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'No',
                style: TextStyle(color: Color(0xFF2196F3)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<WaitingCarpoolBloc>().add(const CancelCarpool());
              },
              child: const Text(
                'Sí, Cancelar',
                style: TextStyle(color: Color(0xFFE53935)),
              ),
            ),
          ],
        );
      },
    );
  }
}