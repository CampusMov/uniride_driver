import 'package:flutter/cupertino.dart';

class CircleIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CircleIndicator({
    super.key,
    required this.color,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}