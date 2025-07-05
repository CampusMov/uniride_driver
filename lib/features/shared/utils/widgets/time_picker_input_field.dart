import 'package:flutter/material.dart';

class TimePickerInputField extends StatefulWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimeChange;
  final String placeholder;
  final bool enabled;

  const TimePickerInputField({
    super.key,
    this.time,
    required this.onTimeChange,
    this.placeholder = 'Selecciona hora',
    this.enabled = true,
  });

  @override
  State<TimePickerInputField> createState() => _TimePickerInputFieldState();
}

class _TimePickerInputFieldState extends State<TimePickerInputField> {

  Future<void> _openTimePicker() async {
    if (!widget.enabled) return;

    setState(() {
    });

    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: widget.time ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              // Custom theme similar to R.style.CustomTimePickerTheme
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Color(0xFF3F4042),
                onSurface: Colors.white,
                secondary: Color(0xFF3F4042),
                onSecondary: Colors.white,
              ),
              timePickerTheme: const TimePickerThemeData(
                backgroundColor: Color(0xFF3F4042),
                hourMinuteTextColor: Colors.white,
                hourMinuteColor: Color(0xFF2D2D2D),
                dayPeriodTextColor: Colors.white,
                dayPeriodColor: Color(0xFF2D2D2D),
                dialHandColor: Colors.white,
                dialBackgroundColor: Color(0xFF2D2D2D),
                dialTextColor: Colors.white,
                entryModeIconColor: Colors.white,
                helpTextStyle: TextStyle(color: Colors.white),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Color(0xFF2D2D2D),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        widget.onTimeChange(picked);
      }
    } finally {
      setState(() {
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';

    // Format as "hh:mm a" (12-hour format with AM/PM)
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _formatTime(widget.time);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3F4042),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(3.0),
      child: TextField(
        readOnly: true,
        enabled: false, // Always disabled as in Kotlin
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
