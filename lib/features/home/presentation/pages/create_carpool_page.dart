import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/btn_style_paletter.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_text_field.dart';
import 'package:uniride_driver/core/ui/custom_number_input_row.dart';

class CreateCarpoolPage extends StatefulWidget {
  const CreateCarpoolPage({super.key,
  required this.onTap,});

  final VoidCallback onTap;

  @override
  State<CreateCarpoolPage> createState() => _CreateCarpoolPageState();
}

class _CreateCarpoolPageState extends State<CreateCarpoolPage> {

  var _selectDestination = "Av.Primavera 693 (Chacarrilla del estanque)";
  final _destinatedController = TextEditingController();
  var _availableSeats = 0;
  var _pairingRadius = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.adjust, color: ColorPaletter.textPrimary),
            SizedBox(width: 10),
            Text("${_selectDestination}",style: TextStylePaletter.body),
            SizedBox(width: 10),
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
          label: "Cantidad de asientos Disponibles:", 
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
            onPressed: this.widget.onTap,
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