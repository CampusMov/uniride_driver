import 'package:flutter/material.dart';

class DefaultRoundedDateInputField extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final bool showModeToggle;
  final String placeholder;

  const DefaultRoundedDateInputField({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.showModeToggle = false,
    this.placeholder = 'Selecciona fecha',
  });

  @override
  State<DefaultRoundedDateInputField> createState() => _DefaultRoundedDateInputFieldState();
}

class _DefaultRoundedDateInputFieldState extends State<DefaultRoundedDateInputField> {
  bool _showPicker = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _showPicker = false;
  }

  void _showDatePicker() {
    if (_showPicker) {
      _removeOverlay();
      return;
    }

    _showPicker = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 8.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xFF2D2D2D),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: CalendarDatePicker(
                initialDate: widget.selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                onDateChanged: (DateTime date) {
                  widget.onDateSelected(date);
                  _removeOverlay();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    // Formato español: "DD de MMMM del YYYY"
    final day = date.day.toString().padLeft(2, '0');
    final months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    final month = months[date.month];
    final year = date.year.toString();

    return '$day de $month del $year';
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _fieldKey,
        decoration: BoxDecoration(
          color: const Color(0xFF3F4042),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(3.0),
        child: TextField(
          readOnly: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 16.0,
            ),
            suffixIcon: IconButton(
              onPressed: _showDatePicker,
              icon: const Icon(
                Icons.date_range,
                color: Color(0xFFB3B3B3),
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
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
          ),
          controller: TextEditingController(
            text: _formatDate(widget.selectedDate),
          ),
          onTap: _showDatePicker,
        ),
      ),
    );
  }
}
