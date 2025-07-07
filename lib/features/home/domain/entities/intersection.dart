import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Intersection extends Equatable {
  final double latitude;
  final double longitude;

  const Intersection({
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  @override
  List<Object?> get props => [latitude, longitude];
}