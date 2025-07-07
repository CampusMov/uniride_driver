import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_service;
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key, required this.markers, required this.polylines});

  //Variables que necesita el widget
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  location_service.LocationData? _currentLocation;
  final location_service.Location location = location_service.Location();

  final _initialCameraPosition = CameraPosition(
    target: LatLng(-12.046374, -77.042793), // Lima, Perú por defecto
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        // Escuchar cuando necesita centrar el mapa en una posición específica
        if (state is LoadedState && state.centerPosition != null) {
          _centerMapOnPosition(state.centerPosition!);
        }
      },
      child: GoogleMap(
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: _initialCameraPosition,
        markers: widget.markers,
        polylines: widget.polylines,
        cloudMapId: "388b9689db1859ee6852b722",
        compassEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onTap: (position) {
          // Puedes agregar lógica aquí si necesitas
        },
      ),
    );
  }

  Future<void> _centerMapOnPosition(LatLng position) async {
    try {
      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      print('Error al centrar el mapa: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    location_service.PermissionStatus permissionGranted;

    // Verifica que el GPS esté habilitado
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Verifica permisos
    permissionGranted = await location.hasPermission();
    if (permissionGranted == location_service.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != location_service.PermissionStatus.granted) return;
    }

    // Obtiene la ubicación
    final loc = await location.getLocation();

    setState(() {
      _currentLocation = loc;
    });

    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(loc.latitude!, loc.longitude!),
          zoom: 16,
        ),
      ));
    }
  }
}