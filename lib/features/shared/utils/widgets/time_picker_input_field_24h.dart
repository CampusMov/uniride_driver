import 'package:flutter/material.dart';

class TimePickerInputField24H extends StatefulWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimeChange;
  final String placeholder;
  final bool enabled;

  const TimePickerInputField24H({
    super.key,
    this.time,
    required this.onTimeChange,
    this.placeholder = 'Selecciona hora',
    this.enabled = true,
  });

  @override
  State<TimePickerInputField24H> createState() => _TimePickerInputField24HState();
}

class _TimePickerInputField24HState extends State<TimePickerInputField24H> {
  Future<void> _openTimePicker() async {
    if (!widget.enabled) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.time ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Color(0xFF3F4042),
                onSurface: Colors.white,
              ),
              timePickerTheme: const TimePickerThemeData(
                backgroundColor: Color(0xFF3F4042),
                hourMinuteTextColor: Colors.white,
                hourMinuteColor: Color(0xFF2D2D2D),
                dialHandColor: Colors.white,
                dialBackgroundColor: Color(0xFF2D2D2D),
                dialTextColor: Colors.white,
                entryModeIconColor: Colors.white,
                helpTextStyle: TextStyle(color: Colors.white),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      widget.onTimeChange(picked);
    }
  }

  String _formatTime24H(TimeOfDay? time) {
    if (time == null) return '';

    // Format as "HH:mm" (24-hour format)
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _formatTime24H(widget.time);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3F4042),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(3.0),
      child: TextField(
        readOnly: true,
        enabled: widget.enabled,
        style: TextStyle(
          color: formatted.isNotEmpty ? Colors.white : const Color(0xFFB3B3B3),
          fontSize: 16.0,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 16.0,
          ),
          suffixIcon: IconButton(
            onPressed: widget.enabled ? _openTimePicker : null,
            icon: const Icon(
              Icons.access_time,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          filled: true,
          fillColor: const Color(0xFF3F4042),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
        ),
        controller: TextEditingController(text: formatted),
        onTap: widget.enabled ? _openTimePicker : null,
      ),
    );
  }
}