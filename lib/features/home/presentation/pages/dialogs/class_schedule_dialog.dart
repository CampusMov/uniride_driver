import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/carpool/create_carpool_bloc.dart';
import '../../bloc/carpool/create_carpool_event.dart';
import '../../bloc/carpool/create_carpool_state.dart';

class ClassScheduleDialog extends StatefulWidget {
  const ClassScheduleDialog({super.key});

  @override
  State<ClassScheduleDialog> createState() => _ClassScheduleDialogState();
}

class _ClassScheduleDialogState extends State<ClassScheduleDialog> {
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
    return BlocBuilder<CreateCarpoolBloc, CreateCarpoolState>(
      builder: (context, state) {
        // Check if the dialog should be open
        if (!state.isSelectClassScheduleDialogOpen) {
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
                  _buildDialogHeader(context),

                  // Field to search for class schedules
                  _buildSearchField(context),

                  // Results list
                  Expanded(
                    child: _buildResultsList(context, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
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
              'Selecciona tu horario de clase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding:  const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                context.read<CreateCarpoolBloc>().add(
                  const CloseDialogToSelectClassSchedule(),
                );
                _searchController.text = '';
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

  Widget _buildSearchField(BuildContext context) {
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
          hintText: 'Matemáticas, Algoritmos, Física...',
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
              context.read<CreateCarpoolBloc>().add(
                const ClassScheduleSearchChanged(''),
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
          context.read<CreateCarpoolBloc>().add(
            ClassScheduleSearchChanged(value),
          );
        },
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, CreateCarpoolState state) {
    // Si está cargando, mostrar loading
    if (state.isLoadingClassSchedules) {
      return _buildLoadingState();
    }

    // Si el campo está vacío, mostrar estado inicial
    if (_searchController.text.isEmpty) {
      // Si ya hay horarios cargados, mostrarlos todos
      if (state.allClassSchedules.isNotEmpty) {
        return _buildSchedulesList(context, state.allClassSchedules);
      }
      // Si no hay horarios, mostrar estado vacío
      return _buildEmptyState();
    }

    // Si hay búsqueda pero no hay resultados
    if (state.filteredClassSchedules.isEmpty && _searchController.text.isNotEmpty) {
      return _buildNoResultsState();
    }

    // Mostrar resultados filtrados
    return _buildSchedulesList(context, state.filteredClassSchedules);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Cargando horarios...',
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
            Icons.schedule_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Busca tu clase',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa el nombre de tu materia o curso',
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
            'No se encontraron clases',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro nombre de materia',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulesList(BuildContext context, List schedules) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return _buildClassScheduleItem(context, schedule, index);
      },
    );
  }

  Widget _buildClassScheduleItem(BuildContext context, schedule, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.read<CreateCarpoolBloc>().add(
              ClassScheduleSelected(schedule),
            );
            _searchController.text = '';
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de la clase
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getClassColor(index).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: _getClassColor(index),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Información de la clase
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del curso
                      Text(
                        schedule.courseName ?? 'Curso',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Horario
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            schedule.timeRange() ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Día y ubicación
                      Row(
                        children: [
                          // Día
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getClassColor(index).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              schedule.selectedDay?.showDay() ?? 'Lunes',
                              style: TextStyle(
                                color: _getClassColor(index),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Ubicación
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    schedule.locationName ?? 'Aula',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Icono de selección
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.3),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getClassColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}