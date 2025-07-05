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
  
  
  //final Map<MarkerId,Marker> _markers ;

  //Carga
  LoadedState({required this.markers, required this.polylines});

}



class ErrorState extends MapState {
  final String message;

  const ErrorState(this.message);
}