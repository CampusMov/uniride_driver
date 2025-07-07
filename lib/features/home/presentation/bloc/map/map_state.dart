import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {
  const MapState();
}
class InitialState extends MapState {

}

class LoadingState extends MapState {

}

class LoadedState extends MapState {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLng? centerPosition;

  LoadedState({
    required this.markers,
    required this.polylines,
    this.centerPosition,
  });
}

class ErrorState extends MapState {
  final String message;

  const ErrorState(this.message);
}