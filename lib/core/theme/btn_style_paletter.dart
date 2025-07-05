import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';

class BtnStylePaletter {
  static final  ButtonStyle primary =  ElevatedButton.styleFrom(
                            backgroundColor: ColorPaletter.button,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            
                            ),
                          );
}