import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/enum_passenger_request_status.dart';
import '../../../domain/entities/passenger_request.dart';
import '../../bloc/passenger-request/passenger_request_bloc.dart';
import '../../bloc/passenger-request/passenger_request_event.dart';
import '../../bloc/passenger-request/passenger_request_state.dart';

class PassengerRequestDialog extends StatefulWidget {
  const PassengerRequestDialog({super.key});

  @override
  State<PassengerRequestDialog> createState() => _PassengerRequestDialogState();
}

class _PassengerRequestDialogState extends State<PassengerRequestDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // When the dialog is opened, focus on the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PassengerRequestBloc, PassengerRequestState>(
      listener: (context, state) {
        // Show success/error messages
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${state.successMessage}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        // Check if the dialog should be open
        if (!state.isDialogOpen) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header of the dialog
                  _buildDialogHeader(context, state),

                  // Filter chips
                  _buildFilterChips(context, state),

                  // Search field
                  _buildSearchField(context, state),

                  // Statistics bar
                  _buildStatisticsBar(context, state),

                  // Results list
                  Expanded(
                    child: _buildRequestsList(context, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(BuildContext context, PassengerRequestState state) {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 50),
          const Expanded(
            child: Text(
              'Solicitudes de Pasajeros',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                context.read<PassengerRequestBloc>().add(
                  const CloseRequestsManagementDialog(),
                );
                _searchController.clear();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, PassengerRequestState state) {
    final filters = [
      {'key': 'all', 'label': 'Todas', 'icon': Icons.list},
      {'key': 'pending', 'label': 'Pendientes', 'icon': Icons.hourglass_empty},
      {'key': 'accepted', 'label': 'Aceptadas', 'icon': Icons.check_circle},
      {'key': 'rejected', 'label': 'Rechazadas', 'icon': Icons.cancel},
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = state.currentFilter == filter['key'];
          final count = _getFilterCount(state, filter['key'] as String);

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                context.read<PassengerRequestBloc>().add(
                  ChangeRequestsFilter(filter['key'] as String),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      color: isSelected ? Colors.orange : Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.orange : Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, PassengerRequestState state) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3F4042),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o ubicación...',
          hintStyle: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFB3B3B3),
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
            onTap: () {
              _searchController.clear();
              context.read<PassengerRequestBloc>().add(
                const SearchRequests(''),
              );
            },
            child: const Icon(
              Icons.clear,
              color: Color(0xFFB3B3B3),
              size: 20,
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Para actualizar el suffixIcon
          context.read<PassengerRequestBloc>().add(
            SearchRequests(value),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsBar(BuildContext context, PassengerRequestState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildStatItem('Total', state.allRequests.length, Colors.blue),
          const SizedBox(width: 20),
          _buildStatItem('Pendientes', state.pendingRequestsCount, Colors.orange),
          const SizedBox(width: 20),
          _buildStatItem('Aceptadas', state.acceptedRequestsCount, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList(BuildContext context, PassengerRequestState state) {
    // Si está cargando, mostrar loading
    if (state.isLoadingRequests) {
      return _buildLoadingState();
    }

    // Si no hay requests
    if (state.allRequests.isEmpty) {
      return _buildEmptyState();
    }

    // Si no hay resultados filtrados
    if (state.filteredRequests.isEmpty) {
      return _buildNoResultsState();
    }

    // Mostrar lista de requests
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: state.filteredRequests.length,
      itemBuilder: (context, index) {
        final request = state.filteredRequests[index];
        return _buildPassengerRequestItem(context, state, request, index);
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Cargando solicitudes...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay solicitudes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las solicitudes de pasajeros aparecerán aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron solicitudes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta cambiar el filtro o búsqueda',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerRequestItem(
      BuildContext context,
      PassengerRequestState state,
      PassengerRequest request,
      int index
      ) {
    final isSelected = state.isRequestSelected(request.id);
    final isExpanded = state.isRequestExpanded(request.id);
    final isProcessing = state.isRequestBeingProcessed(request.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.orange.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.orange.withOpacity(0.3))
                : null,
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.read<PassengerRequestBloc>().add(
                    ToggleRequestDetails(request.id),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar del pasajero
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getStatusColor(request.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person,
                          color: _getStatusColor(request.status),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Información del pasajero
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre y asientos
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    request.pickupLocation.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildStatusChip(request.status),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Ubicación de recogida
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    request.pickupLocation.address,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Asientos solicitados
                            Row(
                              children: [
                                Icon(
                                  Icons.airline_seat_recline_normal,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${request.requestedSeats} asiento${request.requestedSeats > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Indicador de expansión y processing
                      Column(
                        children: [
                          if (isProcessing)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                              ),
                            )
                          else
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white.withOpacity(0.3),
                              size: 24,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Sección expandida con acciones
              if (isExpanded && request.status == PassengerRequestStatus.pending)
                _buildExpandedActions(context, request, isProcessing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedActions(BuildContext context, PassengerRequest request, bool isProcessing) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isProcessing
                  ? null
                  : () {
                context.read<PassengerRequestBloc>().add(
                  AcceptPassengerRequest(
                    passengerRequestId: request.id,
                    message: "¡Perfecto! Te veo en el punto de encuentro.",
                  ),
                );
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Aceptar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isProcessing
                  ? null
                  : () {
                context.read<PassengerRequestBloc>().add(
                  RejectPassengerRequest(
                    passengerRequestId: request.id,
                    reason: "Lo siento, no hay asientos disponibles.",
                  ),
                );
              },
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Rechazar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(PassengerRequestStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case PassengerRequestStatus.pending:
        color = Colors.orange;
        text = 'Pendiente';
        icon = Icons.hourglass_empty;
        break;
      case PassengerRequestStatus.accepted:
        color = Colors.green;
        text = 'Aceptada';
        icon = Icons.check_circle;
        break;
      case PassengerRequestStatus.rejected:
        color = Colors.red;
        text = 'Rechazada';
        icon = Icons.cancel;
        break;
      case PassengerRequestStatus.cancelled:
        color = Colors.grey;
        text = 'Cancelada';
        icon = Icons.block;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PassengerRequestStatus status) {
    switch (status) {
      case PassengerRequestStatus.pending:
        return Colors.orange;
      case PassengerRequestStatus.accepted:
        return Colors.green;
      case PassengerRequestStatus.rejected:
        return Colors.red;
      case PassengerRequestStatus.cancelled:
        return Colors.grey;
    }
  }

  int _getFilterCount(PassengerRequestState state, String filter) {
    switch (filter) {
      case 'all':
        return state.allRequests.length;
      case 'pending':
        return state.pendingRequestsCount;
      case 'accepted':
        return state.acceptedRequestsCount;
      case 'rejected':
        return state.rejectedRequestsCount;
      default:
        return 0;
    }
  }
}