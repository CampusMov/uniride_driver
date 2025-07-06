import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';

class BtnsAddUserAndLocationView extends StatelessWidget {
  const BtnsAddUserAndLocationView({super.key,required this.onTapUser,required this.onTapLocation});

  final VoidCallback onTapUser;
  final VoidCallback onTapLocation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
            right: 16,                    
            top: MediaQuery.of(context).size.height * 0.5 - 45, // Centrado verticalmente
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: "solicitude",
                  onPressed: onTapUser,
                  backgroundColor: ColorPaletter.btnHome,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Más redondeado
                  ),
                  child: Icon(
                    Icons.supervisor_account, 
                    color: ColorPaletter.iconBtnHome, 
                    size: 30.0),
                ),
                SizedBox(width: 10), // Espacio entre botones
                FloatingActionButton(
                  heroTag: "myLocation",
                  onPressed: onTapLocation,
                  backgroundColor: ColorPaletter.btnHome,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Más redondeado
                  ),
                  child: Icon(
                    Icons.place, 
                    color: ColorPaletter.iconBtnHome, 
                    size: 30.0),
                )
              ],
            ),
          );
          
  }
}