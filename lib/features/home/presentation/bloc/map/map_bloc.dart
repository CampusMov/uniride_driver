import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(InitialState()) {
    
    Set<Marker> _markers = {};

    on<InitialMap>((event,emit) async {
      emit(LoadingState());
        
        final markers = <Marker>{
        
          Marker(
            markerId: const MarkerId('initialPosition'),
            position: event.initialPosition,
            infoWindow: const InfoWindow(title: 'Posición inicial'),
          ),
          Marker(
            markerId: const MarkerId('destinationPosition'),
            position: event.destinationPosition,
            infoWindow: const InfoWindow(title: 'Posición final'),
          ),
        };
        
        PolylinePoints polylinePoints = PolylinePoints();
        final result = await polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            origin: PointLatLng(event.initialPosition.latitude,event.initialPosition.longitude),
            destination: PointLatLng(event.destinationPosition.latitude,event.destinationPosition.longitude),
            mode: TravelMode.driving,
          ),
         googleApiKey: ApiConstants.googleMapApiKey
        );

        final points = result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
        
        final polyline = Polyline(
          polylineId: const PolylineId('route'),
          color: ColorPaletter.warning,
          width: 5,
          points: points
        );

        emit(LoadedState( markers: markers, polylines: {polyline} ));
    });

    on<AddMarker>((event, emit) {
      final markerId = MarkerId(event.position.toString());
      final marker = Marker(
        markerId: markerId,
        position: event.position,
        infoWindow: InfoWindow(title: 'Marker at ${event.position.latitude}, ${event.position.longitude}'),
      );

      _markers.add(marker);
      
      Set<Polyline> polylines = {};
      if (state is LoadedState) {
        polylines = (state as LoadedState).polylines;
      }
      
      emit(LoadedState(markers: _markers, polylines: polylines));
    });


 
  }

}