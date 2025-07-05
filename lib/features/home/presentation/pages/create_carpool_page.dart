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

class CreateCarpoolPage extends StatefulWidget {
  const CreateCarpoolPage({super.key,
  required this.onTap,});

  final ValueChanged<bool> onTap;

  
  @override
  State<CreateCarpoolPage> createState() => _CreateCarpoolPageState();
}

class _CreateCarpoolPageState extends State<CreateCarpoolPage> {
  //Nombre de la ubiaciones seleccionadas
  String? _selectedDestination;
  String? _selectedOrigin;
  //Variables que guardan las ubicaciones seleccionadas
  LatLng? destinationPosition;
  LatLng? initialPosition;

  //input de clases
  final _destinatedController = TextEditingController();

  //Asientos disponibles y radio de emparejamiento
  var _availableSeats = 0;
  var _pairingRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selecciona el lugar de partida
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.adjust, color: ColorPaletter.textPrimary),
                  SizedBox(width: 10),
                  //Escucha el evento de selecionar un lugar de origen y cambia de valor el 
                  Expanded(
                    child: BlocListener<SelectLocationBloc,SelectLocationState>(
                      listener: (context,state){
                        if (state is SelectLocationLoadesOrigin) {
                          setState(() {
                            initialPosition = LatLng(
                              double.parse(state.locationOrigin.latitude), 
                              double.parse(state.locationOrigin.longitude));

                            _selectedOrigin = state.locationOrigin.address;
                          });
                        }
                      },
                      child: Text(
                        _selectedOrigin ?? "Selecciona lugar de Inicio",
                        style: TextStylePaletter.body,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              
              onPressed:(){
                 widget.onTap(true);
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
        SizedBox(height: 10),
        //Selecciona el lugar de destino
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
                            
        CustomTextField(
          icon: Icon(Icons.search, color: ColorPaletter.textPrimary),
          editingController: _destinatedController,
          hintText: 'Buscar destino',
        ),

        SizedBox(height: 20),

        CustomNumberInputRow(
          label: "Asientos Disponibles:", 
          value: _availableSeats, 
          onDecrement: (){
            if (_availableSeats > 0) {
              setState(() {
                _availableSeats--;
              });
            }
          }, 
          onIncrement: (){
            setState(() {
                _availableSeats++;
            });
          }
        ),
        CustomNumberInputRow(
          label: "Radio de emparejamiento:", 
          value: _pairingRadius, 
          onDecrement: (){
            if (_pairingRadius > 0) {
              setState(() {
                _pairingRadius--;
              });
            }
          }, 
          onIncrement: (){
            setState(() {
                _pairingRadius++;
            });
          }
        ),
      
        SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){},
            style: BtnStylePaletter.primary,

            child: Text("Buscar emparejamiento",
              style: TextStylePaletter.button, 
            ),
          ),
        ),


      ],
    );
  }
}