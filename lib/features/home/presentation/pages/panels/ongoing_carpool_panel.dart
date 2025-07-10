import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/carpool/on_going_carpool_bloc.dart';
import '../../bloc/carpool/on_going_carpool_event.dart';
import '../../bloc/carpool/on_going_carpool_state.dart';

class OnGoingCarpoolPanel extends StatelessWidget {
  const OnGoingCarpoolPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnGoingCarpoolBloc, OnGoingCarpoolState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, OnGoingCarpoolState state) {
    // Mostrar loading si está cargando
    if (state.isLoading) {
      return _buildLoadingPanel();
    }

    // Mostrar error si hay error
    if (state.errorMessage != null) {
      return _buildErrorPanel(context, state.errorMessage!);
    }

    // Mostrar panel principal si está inicializado
    if (state.isInitialized) {
      return _buildLoadedPanel(context, state);
    }

    // Por defecto no mostrar nada
    return const SizedBox.shrink();
  }

  Widget _buildLoadingPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            strokeWidth: 2,
          ),
          SizedBox(width: 16),
          Text(
            'Cargando carpool...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedPanel(BuildContext context, OnGoingCarpoolState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con hora estimada de llegada
          _buildArrivalTimeHeader(state.estimatedArrivalTime),

          const SizedBox(height: 8),

          // Duración y distancia
          _buildDurationDistanceRow(
              state.estimatedDurationText ?? 'N/A',
              state.estimatedDistanceText ?? 'N/A'
          ),

          const SizedBox(height: 8),

          // Precio del carpool
          _buildPriceRow(state.carpool!),

          const SizedBox(height: 16),

          // Ubicaciones de origen y destino
          _buildLocationInfo(state.carpool!),

          const SizedBox(height: 16),

          // Información del conductor y tracking status
          _buildDriverInfo(state),

          const SizedBox(height: 16),

          // Botón de finalizar carpool (solo cuando esté cerca)
          if (state.isNearDestination) _buildFinishButton(context, state.isFinishingCarpool),
        ],
      ),
    );
  }

  Widget _buildArrivalTimeHeader(DateTime? estimatedArrival) {
    String timeText = 'N/A';

    if (estimatedArrival != null) {
      timeText = DateFormat('H:mm').format(estimatedArrival);
    }

    return Center(
      child: Text(
        timeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDurationDistanceRow(String duration, String distance) {
    return Center(
      child: Text(
        '$duration - $distance',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriceRow(carpool) {
    return Center(
      child: Text(
        'S/20.50', // Por ahora hardcoded, cambiar cuando tengas el campo precio en Carpool
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationInfo(carpool) {
    return Column(
      children: [
        // Origen
        _buildLocationRow(
          icon: Icons.radio_button_checked,
          label: 'Partida',
          location: carpool.origin.name,
          address: carpool.origin.address,
          isOrigin: true,
        ),

        const SizedBox(height: 12),

        // Destino
        _buildLocationRow(
          icon: Icons.location_on,
          label: 'Destino',
          location: carpool.destination.name,
          address: carpool.destination.address,
          isOrigin: false,
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String location,
    required String address,
    required bool isOrigin,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isOrigin ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (address.isNotEmpty)
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(OnGoingCarpoolState state) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          color: Colors.white70,
          size: 20,
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '2.6 Conductor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Indicador de tracking
        _buildTrackingIndicator(state.isLocationTracking),
      ],
    );
  }

  Widget _buildTrackingIndicator(bool isTracking) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isTracking ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTracking ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isTracking ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isTracking ? 'En vivo' : 'Sin señal',
            style: TextStyle(
              color: isTracking ? Colors.green : Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton(BuildContext context, bool isFinishing) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFinishing ? null : () {
          _showFinishCarpoolDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        child: isFinishing
            ? const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Finalizando...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Finalizar Carpool',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPanel(BuildContext context, String errorMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 32,
          ),
          const SizedBox(height: 8),
          const Text(
            'Error en el carpool',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Limpiar mensajes de error
              context.read<OnGoingCarpoolBloc>().state.clearMessages();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showFinishCarpoolDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.flag, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Finalizar Carpool',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que quieres finalizar este carpool? Esta acción no se puede deshacer.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<OnGoingCarpoolBloc>().add(const FinishCarpool());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Finalizar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}