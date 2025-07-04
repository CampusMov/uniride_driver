import 'package:flutter/material.dart';


class DefaultRoundedInputField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onValueChange;
  final String placeholder;
  final TextInputType keyboardType;
  final bool singleLine;
  final bool enabled;
  final bool enableLeadingIcon;
  final IconData? leadingIcon;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const DefaultRoundedInputField({
    super.key,
    required this.value,
    required this.onValueChange,
    required this.placeholder,
    this.keyboardType = TextInputType.text,
    this.singleLine = true,
    this.enabled = true,
    this.enableLeadingIcon = false,
    this.leadingIcon,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF3F4042),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          enabled: enabled,
          onChanged: onValueChange,
          keyboardType: keyboardType,
          maxLines: singleLine ? 1 : null,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 16,
            ),
            filled: true,
            fillColor: const Color(0xFF3F4042),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Color(0xFF3F4042),
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Color(0xFF3F4042),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Color(0xFF3F4042),
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            prefixIcon: enableLeadingIcon
                ? Icon(
              leadingIcon ?? Icons.search,
              color: const Color(0xFFB3B3B3),
              size: 24,
            )
                : null,
            suffixIcon: enabled && value.isNotEmpty
                ? IconButton(
              onPressed: () => onValueChange(''),
              icon: const Icon(
                Icons.clear,
                color: Color(0xFFB3B3B3),
                size: 24,
              ),
              splashRadius: 20,
            )
                : null,
          ),
        ),
      ),
    );
  }
}