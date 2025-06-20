
import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.icon,
    this.hintText,
    this.editingController,
    this.onChanged,
    this.onSubmitted
  });
  final Icon? icon;
  final String? hintText;
  final TextEditingController? editingController;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      onChanged: onChanged,
      onSubmitted:  onSubmitted,
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