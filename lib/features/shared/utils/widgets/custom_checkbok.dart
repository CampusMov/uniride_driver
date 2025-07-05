import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color checkColor;
  final Color fillColor;
  final Color borderColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.checkColor = Colors.black,
    this.fillColor = Colors.white,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: value ? fillColor : Colors.transparent,
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: value
            ? Icon(
          Icons.check,
          color: checkColor,
          size: 16.0,
        )
            : null,
      ),
    );
  }
}
