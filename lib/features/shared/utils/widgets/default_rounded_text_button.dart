import 'package:flutter/material.dart';

class DefaultRoundedTextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool enabledRightIcon;
  final IconData? rightIcon;
  final bool isLoading;
  final String? loadingText;
  final Color backgroundColor;
  final Color textColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;

  const DefaultRoundedTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.enabledRightIcon = false,
    this.rightIcon,
    this.isLoading = false,
    this.loadingText,
    this.backgroundColor = const Color(0xFFC4C4C4),
    this.textColor = Colors.black,
    this.disabledBackgroundColor = const Color(0xFF8C8C8C),
    this.disabledTextColor = Colors.black,
  });

  @override
  State<DefaultRoundedTextButton> createState() => _DefaultRoundedTextButtonState();
}

class _DefaultRoundedTextButtonState extends State<DefaultRoundedTextButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    if (widget.isLoading) {
      _startLoadingAnimation();
    }
  }

  @override
  void didUpdateWidget(DefaultRoundedTextButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _startLoadingAnimation();
      } else {
        _stopLoadingAnimation();
      }
    }
  }

  void _startLoadingAnimation() {
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _dotCount = (_dotCount % 3) + 1;
        });
        if (widget.isLoading) {
          _animationController.reset();
          _animationController.forward();
        }
      }
    });
    _animationController.forward();
  }

  void _stopLoadingAnimation() {
    _animationController.stop();
    _animationController.removeStatusListener((status) {});
    setState(() {
      _dotCount = 0;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = widget.enabled && !widget.isLoading;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isButtonEnabled ? widget.onPressed : null,
        style: TextButton.styleFrom(
          backgroundColor: isButtonEnabled
              ? widget.backgroundColor
              : widget.disabledBackgroundColor,
          foregroundColor: isButtonEnabled
              ? widget.textColor
              : widget.disabledTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: widget.isLoading
                    ? Text(
                  '${widget.loadingText ?? widget.text}${'.' * _dotCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 40 / 20, // lineHeight equivalent
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 40 / 20, // lineHeight equivalent
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.enabledRightIcon && !widget.isLoading)
                Icon(
                  widget.rightIcon ?? Icons.arrow_forward,
                  color: isButtonEnabled
                      ? widget.textColor
                      : widget.disabledTextColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}