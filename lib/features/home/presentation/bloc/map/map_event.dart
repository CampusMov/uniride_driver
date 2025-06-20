import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {
  const MapEvent();
}

class InitialMap extends MapEvent{

  final LatLng destinationPosition;
  final LatLng initialPosition;
  
  InitialMap({
    required this.destinationPosition,
    required this.initialPosition,
  });
}

//https://maps.googleapis.com/maps/api/directions/json?origin=-12.117642,-77.000320&destination=-12.111348,-77.000920&key=AIzaSyAmc--LhYp4c9_v4HrU4bITMBx6Dx1tVO0



class AddMarker extends MapEvent{
  final LatLng position;
  const AddMarker(this.position);
}

class GetLocation extends MapEvent{

}