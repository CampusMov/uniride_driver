import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';

Widget CustomNumberInputRow({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStylePaletter.body,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
              onPressed: onDecrement,
            ),
            Text(
              value.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

