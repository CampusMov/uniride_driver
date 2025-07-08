import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  final String id;
  final LatLng position;
  final String title;
  final String snippet;
  final BitmapDescriptor? icon;
  final VoidCallback? onTap;

  const MarkerData({
    required this.id,
    required this.position,
    required this.title,
    this.snippet = '',
    this.icon,
    this.onTap,
  });
}