
import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.icon,
    this.hintText,
    this.editingController,
  });
  final Icon? icon;
  final String? hintText;
  final TextEditingController? editingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      cursorColor: ColorPaletter.textinputField,
      style: TextStylePaletter.inputField,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: TextStylePaletter.inputField,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: ColorPaletter.inputField,
      ),

    );
  }
}