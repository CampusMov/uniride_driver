import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/home/domain/entities/route.dart';
import 'package:uniride_driver/features/home/domain/repositories/route_repository.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final RouteRepository routeRepository;

  MapBloc({
    required this.routeRepository,
}) : super(InitialState()) {
    
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

    on<GetRoute>((event, emit) async {
      try {
        final result = await routeRepository.getRoute(
          event.routeRequestModel.startLatitude,
          event.routeRequestModel.startLongitude,
          event.routeRequestModel.endLatitude,
          event.routeRequestModel.endLongitude,
        );

        switch (result) {
          case Success<Route>():
            log('TAG: MapBloc - GetRoute - Success: ${result.data}');
            if (result.data.intersections.isEmpty) {
              log('TAG: MapBloc - GetRoute - Intersections are empty');
              return;
            }
            final markers = <Marker>{
              Marker(
                markerId: const MarkerId('initialPosition'),
                position: LatLng(result.data.intersections[0].latitude, result.data.intersections[0].longitude),
                infoWindow: const InfoWindow(title: 'Posición inicial'),
              ),
              Marker(
                markerId: const MarkerId('destinationPosition'),
                position: LatLng(result.data.intersections[result.data.intersections.length - 1].latitude, result.data.intersections[result.data.intersections.length - 1].longitude),
                infoWindow: const InfoWindow(title: 'Posición final'),
              ),
            };
            final polyline = Polyline(
              polylineId: const PolylineId('route'),
              color: ColorPaletter.warning,
              width: 5,
              points: result.data.intersections.map((e) => LatLng(e.latitude, e.longitude)).toList(),
            );

            emit(LoadedState(markers: markers, polylines: {polyline}));

            break;
          case Failure<Route>():
            log('TAG: MapBloc - GetRoute - Failure: ${result.message}');
            return;
          case Loading<Route>():
            log('TAG: MapBloc - GetRoute - Loading');
            return;
        }
      } catch (e) {
        emit(ErrorState(e.toString()));
        log('TAG: MapBloc - GetRoute - Error: $e');
      }
    });

  }

}