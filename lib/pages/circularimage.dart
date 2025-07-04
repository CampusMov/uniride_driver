import 'package:flutter/material.dart';
import 'dart:io';

class CircularImage extends StatelessWidget {
  final double size;
  final String imagePath;
  final BoxFit fit;
  final bool isNetworkImage;
  final bool isFileImage;

  const CircularImage({
    super.key,
    required this.size,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.isNetworkImage = false,
    this.isFileImage = false,
  });

  @override
  Widget build(BuildContext context) {

    ImageProvider image;

    if (isNetworkImage) {
      image = NetworkImage(imagePath);
    } else if (isFileImage) {
      image = FileImage(File(imagePath));
    } else {
      image = AssetImage(imagePath);
    }

    return ClipOval(
      child: Container(
        width: 140,
        height: 140,
        color: Colors.grey[200], 
        child: Image(
          image: image,
          fit: fit,
        ),
      ),
    );
  }
}
