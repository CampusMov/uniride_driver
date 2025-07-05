import 'package:flutter/material.dart';

class DefaultRoundedDropdownField<T> extends StatefulWidget {
  final List<String> options;
  final T? selectedOption;
  final Function(String) onOptionSelected;
  final String placeholder;
  final Map<T, String>? optionLabels;

  const DefaultRoundedDropdownField({
    super.key,
    required this.options,
    this.selectedOption,
    required this.onOptionSelected,
    this.placeholder = 'Selecciona una opción',
    this.optionLabels,
  });

  @override
  State<DefaultRoundedDropdownField<T>> createState() => _DefaultRoundedDropdownFieldState<T>();
}

class _DefaultRoundedDropdownFieldState<T> extends State<DefaultRoundedDropdownField<T>> {
  bool _expanded = false;
  String? _selectedOptionText;
  final GlobalKey _fieldKey = GlobalKey();
  Size _textFieldSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _updateSelectedOptionText();
  }

  @override
  void didUpdateWidget(DefaultRoundedDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      _updateSelectedOptionText();
    }
  }

  void _updateSelectedOptionText() {
    if (widget.selectedOption != null) {
      if (widget.optionLabels != null && widget.optionLabels!.containsKey(widget.selectedOption)) {
        _selectedOptionText = widget.optionLabels![widget.selectedOption];
      } else {
        _selectedOptionText = widget.selectedOption.toString();
      }
    } else {
      _selectedOptionText = null;
    }
  }

  void _measureTextField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _textFieldSize = renderBox.size;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _fieldKey,
      decoration: BoxDecoration(
        color: const Color(0xFF3F4042),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          TextField(
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
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                  if (_expanded) {
                    _measureTextField();
                  }
                },
                icon: Icon(
                  _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: const Color(0xFFB3B3B3),
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
              text: _selectedOptionText ?? '',
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
              if (_expanded) {
                _measureTextField();
              }
            },
          ),
          if (_expanded)
            Container(
              width: _textFieldSize.width > 0 ? _textFieldSize.width : double.infinity,
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.2 * 255).round()),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedOptionText = option;
                        _expanded = false;
                      });
                      widget.onOptionSelected(option);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}