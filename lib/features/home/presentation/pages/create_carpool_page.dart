import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uniride_driver/core/theme/btn_style_paletter.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_text_field.dart';
import 'package:uniride_driver/core/ui/custom_number_input_row.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_state.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_state.dart';

import '../widgets/class_schedule_selection_dialog.dart';
import '../widgets/origin_location_selection_dialog.dart';
// Crear el archivo: lib/features/home/presentation/widgets/class_schedule_selection_dialog.dart
// Y usar este import:
// import 'package:uniride_driver/features/home/presentation/widgets/class_schedule_selection_dialog.dart';

class CreateCarpoolPage extends StatefulWidget {
  const CreateCarpoolPage({
    super.key,
    required this.onTap,
    this.isInitiallyStarted = false,
    this.onModeChanged,
    this.onNavigateToDetails,
  });

  final ValueChanged<bool> onTap;
  final bool isInitiallyStarted;
  final ValueChanged<bool>? onModeChanged;
  final VoidCallback? onNavigateToDetails;

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
      appBar: !_isCreateMode ? AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _isCreateMode = true;
            });
            // Notificar al padre que el modo cambió de vuelta a crear
            widget.onModeChanged?.call(false); // false = carpool no iniciado
          },
        ),
        elevation: 0,
      ) : null,
      body: SafeArea(
        child: BlocBuilder<CreateCarpoolBloc, CreateCarpoolState>(
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
                      SizedBox(height: 10),

                      //Selecciona el lugar de destino
                      if(!_isCreateMode)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.adjust, color: ColorPaletter.textPrimary),
                                  SizedBox(width: 10),
                                  //Escucha el evento de pulsar clic en una opcion de posibles lugares y reconstruye la pagina
                                  Expanded(
                                    child: BlocListener<SelectLocationBloc,SelectLocationState>(
                                      listener: (context,state){
                                        if (state is SelectLocationLoadesDestination) {
                                          setState(() {
                                            destinationPosition = LatLng(
                                                double.parse(state.locationDestination.latitude),
                                                double.parse(state.locationDestination.longitude));

                                            _selectedDestination = state.locationDestination.address;
                                            //Evento de prueba para dibujar en mapa

                                            context.read<MapBloc>().add(InitialMap(
                                              destinationPosition: destinationPosition!,
                                              initialPosition: initialPosition!,)

                                            );
                                          });
                                        }
                                      },
                                      child: Text(
                                        _selectedDestination ?? "Selecciona lugar de Destino",
                                        style: TextStylePaletter.body,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Destino
                            ElevatedButton(
                              onPressed: (){
                                widget.onTap(false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPaletter.inputField, // Color de fondo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Borde redondeado
                                ),
                                minimumSize: Size(70, 30), // Tamaño mínimo del botón
                              ),
                              child: Text(
                                "Destino",
                                style: TextStylePaletter.body,
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 20),

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

                      // Show class schedule details if selected
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
                              setState(() {
                                _isCreateMode = false;
                              });
                              // Notificar al padre que el modo cambió
                              widget.onModeChanged?.call(true); // true = carpool iniciado
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

                          child: Text(_isCreateMode ? "Crear Carpool" : "Iniciar Carpool",
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