import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uniride_driver/core/theme/btn_style_paletter.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_number_input_row.dart';
import 'package:uniride_driver/features/home/data/model/route_request_model.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_state.dart';

import '../../../../core/utils/resource.dart';
import '../widgets/class_schedule_selection_dialog.dart';
import '../widgets/origin_location_selection_dialog.dart';

class CreateCarpoolPage extends StatefulWidget {
  const CreateCarpoolPage({
    super.key,
    required this.onTap,
    this.isInitiallyStarted = false,
    this.onModeChanged,
    this.onNavigateToDetails,
    this.onRouteRequest,
  });

  final ValueChanged<bool> onTap;
  final bool isInitiallyStarted;
  final ValueChanged<bool>? onModeChanged;
  final VoidCallback? onNavigateToDetails;
  final ValueChanged<RouteRequestModel>? onRouteRequest;

  @override
  State<CreateCarpoolPage> createState() => _CreateCarpoolPageState();
}

class _CreateCarpoolPageState extends State<CreateCarpoolPage> {
  //Nombre de la ubicaciones seleccionadas
  String? _selectedDestination;
  String? _selectedOrigin;
  //Variables que guardan las ubicaciones seleccionadas
  LatLng? destinationPosition;
  LatLng? initialPosition;

  // Booleano para controlar el modo: true = Crear, false = Iniciar
  bool _isCreateMode = true;

  @override
  void initState() {
    super.initState();
    _isCreateMode = !widget.isInitiallyStarted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPaletter.background,
      body: SafeArea(
        child: BlocConsumer<CreateCarpoolBloc, CreateCarpoolState>(
          listener: (context, state) {
            // Manejar el éxito de la creación del carpool
            if (state.carpoolCreationResult != null) {
              if (state.carpoolCreationResult is Success) {
                // Carpool creado exitosamente
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Carpool creado exitosamente!'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Cambiar al modo "Iniciar"
                setState(() {
                  _isCreateMode = false;
                });

                // Notificar al padre que el modo cambió
                widget.onModeChanged?.call(true); // true = carpool iniciado
                widget.onRouteRequest?.call(
                  RouteRequestModel(
                      startLatitude : state.originLocation?.latitude ?? 0.0,
                      startLongitude: state.originLocation?.longitude ?? 0.0,
                      endLatitude: state.classSchedule?.latitude ?? 0.0,
                      endLongitude: state.classSchedule?.longitude ?? 0.0
                  ),
                );

              } else if (state.carpoolCreationResult is Failure) {
                // Error al crear carpool
                final failure = state.carpoolCreationResult as Failure;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al crear carpool: ${failure.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              // Limpiar el resultado después de procesarlo
              context.read<CreateCarpoolBloc>()
                  .add(const ClearCarpoolCreationResult());
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Selecciona el lugar de partida
                      GestureDetector(
                        onTap: () {
                          context.read<CreateCarpoolBloc>()
                              .add(const OpenDialogToSelectOriginLocation());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.adjust, color: ColorPaletter.textPrimary),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      state.originLocation?.address ?? "Selecciona lugar de Inicio",
                                      style: state.originLocation != null
                                          ? TextStylePaletter.body
                                          : TextStylePaletter.body.copyWith(color: ColorPaletter.textSecondary),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                context.read<CreateCarpoolBloc>()
                                    .add(const OpenDialogToSelectOriginLocation());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPaletter.inputField,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(70, 30),
                              ),
                              child: Text(
                                "Partida",
                                style: TextStylePaletter.body,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Mostrar la clase seleccionada cuando no está en modo crear
                      if(!_isCreateMode && state.classSchedule != null)
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: ColorPaletter.inputField,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.school, color: ColorPaletter.textPrimary),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.classSchedule!.courseName,
                                      style: TextStylePaletter.textOptions,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      state.classSchedule!.scheduleTime(),
                                      style: TextStylePaletter.subTextOptions.copyWith(
                                        color: ColorPaletter.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      state.classSchedule!.locationName,
                                      style: TextStylePaletter.spam,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Selector de clase cuando está en modo crear
                      if(_isCreateMode)
                        GestureDetector(
                          onTap: () {
                            context.read<CreateCarpoolBloc>()
                                .add(const OpenDialogToSelectClassSchedule());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            decoration: BoxDecoration(
                              color: ColorPaletter.inputField,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    state.classSchedule?.courseName ?? 'Seleccionar clase',
                                    style: state.classSchedule != null
                                        ? TextStylePaletter.inputField.copyWith(color: Colors.white)
                                        : TextStylePaletter.inputField,
                                  ),
                                ),
                                Icon(
                                  Icons.school,
                                  color: ColorPaletter.textinputField,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Show class schedule details if selected in create mode
                      if(_isCreateMode && state.classSchedule != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: ColorPaletter.inputField.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.classSchedule!.scheduleTime(),
                                style: TextStylePaletter.spam,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                state.classSchedule!.locationName,
                                style: TextStylePaletter.spam,
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 20),

                      CustomNumberInputRow(
                          label: "Asientos Disponibles:",
                          value: state.maxPassengers,
                          onDecrement: (){
                            context.read<CreateCarpoolBloc>()
                                .add(const DecreaseMaxPassengers());
                          },
                          onIncrement: (){
                            context.read<CreateCarpoolBloc>()
                                .add(const IncreaseMaxPassengers());
                          }
                      ),
                      CustomNumberInputRow(
                          label: "Radio de emparejamiento:",
                          value: state.radius,
                          onDecrement: (){
                            context.read<CreateCarpoolBloc>()
                                .add(const DecreaseRadius());
                          },
                          onIncrement: (){
                            context.read<CreateCarpoolBloc>()
                                .add(const IncreaseRadius());
                          }
                      ),

                      SizedBox(height: 20),


                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){
                            if (_isCreateMode) {
                              // Validar que todos los campos estén completos antes de crear
                              if (!state.isValidCarpool) {
                                String missingFields = '';
                                if (state.classSchedule == null) missingFields += '• Seleccionar clase\n';
                                if (state.originLocation == null) missingFields += '• Seleccionar punto de partida\n';
                                if (state.user == null) missingFields += '• Usuario no cargado\n';
                                if (state.vehicle == null) missingFields += '• Vehículo no registrado\n';

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Faltan campos requeridos:\n$missingFields'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                                return;
                              }

                              // Crear el carpool usando el repository
                              context.read<CreateCarpoolBloc>()
                                  .add(const SaveCarpool());
                            } else {
                              //Cambiar ruta al presionar boton
                              widget.onNavigateToDetails?.call();
                              // Solo mostrar un mensaje cuando está en modo Iniciar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Carpool iniciado correctamente'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                            }
                          },
                          style: BtnStylePaletter.primary,

                          child: state.isLoading
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: ColorPaletter.buttonText,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(_isCreateMode ? "Crear Carpool" : "Iniciar Carpool",
                            style: TextStylePaletter.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Class Schedule Dialog Overlay
                if (state.isSelectClassScheduleDialogOpen)
                  const ClassScheduleSelectionDialog(),

                // Origin Location Dialog Overlay
                if (state.isSelectOriginLocationDialogOpen)
                  const OriginLocationSelectionDialog(),
              ],
            );
          },
        ),
      ),
    );
  }
}