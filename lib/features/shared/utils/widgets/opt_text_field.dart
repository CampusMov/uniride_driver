import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpTextField extends StatefulWidget {
  final String otpText;
  final int otpCount;
  final Function(String, bool) onOtpTextChange;

  const OtpTextField({
    super.key,
    required this.otpText,
    this.otpCount = 6,
    required this.onOtpTextChange,
  });

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.otpText);
    _focusNode = FocusNode();

    if (widget.otpText.length > widget.otpCount) {
      throw ArgumentError(
          'Otp text value must not have more than otpCount: ${widget.otpCount} characters'
      );
    }
  }

  @override
  void didUpdateWidget(OtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.otpText != widget.otpText) {
      _controller.text = widget.otpText;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.otpText.length)
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              style: const TextStyle(color: Colors.transparent),
              cursorColor: Colors.transparent,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              maxLength: widget.otpCount,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                if (value.length <= widget.otpCount) {
                  widget.onOtpTextChange(value, value.length == widget.otpCount);
                }
              },
            ),
          ),
          // UI visual of characters
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.otpCount,
                  (index) => Padding(
                padding: EdgeInsets.only(
                  right: index < widget.otpCount - 1 ? 12.0 : 0.0,
                ),
                child: CharView(
                  index: index,
                  text: widget.otpText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CharView extends StatelessWidget {
  final int index;
  final String text;

  const CharView({
    super.key,
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final String char = _getCharAt(index, text);

    return Container(
      height: 60,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontSize: 48,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getCharAt(int index, String text) {
    if (index == text.length) {
      return "";
    } else if (index > text.length) {
      return "";
    } else {
      return text[index];
    }
  }
}