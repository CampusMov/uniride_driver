import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_service;
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';

import '../../../../../core/utils/resource.dart';
import '../../../domain/entities/route.dart';
import '../../../domain/repositories/route_repository.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final RouteRepository routeRepository;

  MapBloc({
    required this.routeRepository,
}) : super(InitialState()) {
    
    Set<Marker> _markers = {};

    on<InitialMap>((event, emit) async {
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
            origin: PointLatLng(event.initialPosition.latitude, event.initialPosition.longitude),
            destination: PointLatLng(event.destinationPosition.latitude, event.destinationPosition.longitude),
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

      emit(LoadedState(markers: markers, polylines: {polyline}));
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

    on<CenterOnUserLocation>((event, emit) async {
      emit(LoadingState());

      try {
        final location = location_service.Location();

        // Verificar servicios y permisos
        bool serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) {
            emit(ErrorState('El servicio de ubicación está deshabilitado'));
            return;
          }
        }

        location_service.PermissionStatus permissionGranted = await location.hasPermission();
        if (permissionGranted == location_service.PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != location_service.PermissionStatus.granted) {
            emit(ErrorState('Permisos de ubicación denegados'));
            return;
          }
        }

        // Obtener ubicación actual
        final locationData = await location.getLocation();

        if (locationData.latitude != null && locationData.longitude != null) {
          final userPosition = LatLng(locationData.latitude!, locationData.longitude!);

          final userMarker = Marker(
            markerId: const MarkerId('userLocation'),
            position: userPosition,
            infoWindow: const InfoWindow(title: 'Tu ubicación'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );

          // Mantener markers existentes y agregar/actualizar el marker del usuario
          Set<Marker> currentMarkers = {};
          if (state is LoadedState) {
            currentMarkers = Set.from((state as LoadedState).markers);
            // Remover marker anterior del usuario si existe
            currentMarkers.removeWhere((marker) => marker.markerId.value == 'userLocation');
          }
          currentMarkers.add(userMarker);

          Set<Polyline> currentPolylines = {};
          if (state is LoadedState) {
            currentPolylines = (state as LoadedState).polylines;
          }

          emit(LoadedState(
            markers: currentMarkers,
            polylines: currentPolylines,
            centerPosition: userPosition,
          ));
        } else {
          emit(ErrorState('No se pudo obtener la ubicación actual'));
        }
      } catch (e) {
        emit(ErrorState('Error al obtener ubicación: $e'));
      }
    });

    on<GetRoute>((event, emit) async {
      print('🗺️ MapBloc - Iniciando GetRoute');
      print('📍 Desde: ${event.routeRequestModel.startLatitude}, ${event.routeRequestModel.startLongitude}');
      print('📍 Hacia: ${event.routeRequestModel.endLatitude}, ${event.routeRequestModel.endLongitude}');

      // Emitir estado de carga
      emit(LoadingState());

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
            print('✅ Ruta obtenida exitosamente');
            print('📊 Intersecciones: ${result.data.intersections.length}');
            print('📏 Distancia total: ${result.data.totalDistance}');
            print('⏱️ Duración total: ${result.data.totalDuration}');

            if (result.data.intersections.isEmpty) {
              log('TAG: MapBloc - GetRoute - Intersections are empty');
              print('⚠️ No hay intersecciones en la ruta');

              // ✅ EN LUGAR DE RETURN, EMITIR UN ESTADO DE ERROR
              emit(ErrorState('No se encontraron intersecciones para la ruta solicitada'));
              return;
            }

            // Crear markers para inicio y fin
            final markers = <Marker>{
              Marker(
                markerId: const MarkerId('initialPosition'),
                position: LatLng(
                    result.data.intersections[0].latitude,
                    result.data.intersections[0].longitude
                ),
                infoWindow: const InfoWindow(title: 'Posición inicial'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
              Marker(
                markerId: const MarkerId('destinationPosition'),
                position: LatLng(
                    result.data.intersections[result.data.intersections.length - 1].latitude,
                    result.data.intersections[result.data.intersections.length - 1].longitude
                ),
                infoWindow: const InfoWindow(title: 'Posición final'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            };

            // Crear polyline para la ruta
            final polyline = Polyline(
              polylineId: const PolylineId('route'),
              color: ColorPaletter.warning,
              width: 5,
              points: result.data.intersections
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            );

            print('✅ Emitiendo estado LoadedState con ${markers.length} markers y 1 polyline');
            emit(LoadedState(markers: markers, polylines: {polyline}));
            break;

          case Failure<Route>():
            log('TAG: MapBloc - GetRoute - Failure: ${result.message}');
            print('❌ Error obteniendo ruta: ${result.message}');
            emit(ErrorState('Error obteniendo ruta: ${result.message}'));
            break;

          case Loading<Route>():
            log('TAG: MapBloc - GetRoute - Loading');
            print('⏳ Cargando ruta...');
            // Ya emitimos LoadingState arriba
            break;
        }
      } catch (e) {
        log('TAG: MapBloc - GetRoute - Exception: $e');
        print('💥 Excepción en GetRoute: $e');
        emit(ErrorState('Error inesperado: ${e.toString()}'));
      }
    });
  }
}


/*
*

* */