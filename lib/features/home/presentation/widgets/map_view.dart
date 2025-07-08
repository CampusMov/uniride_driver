import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_service;
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key, required this.markers, required this.polylines});

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
    print('🗺️ MapViewWidget inicializado');
    print('📍 Markers: ${widget.markers.length}');
    print('📈 Polylines: ${widget.polylines.length}');
  }

  @override
  void didUpdateWidget(MapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ DETECTAR CAMBIOS EN MARKERS Y POLYLINES
    if (oldWidget.markers.length != widget.markers.length ||
        oldWidget.polylines.length != widget.polylines.length) {
      print('🔄 MapViewWidget actualizado');
      print('📍 Markers: ${oldWidget.markers.length} -> ${widget.markers.length}');
      print('📈 Polylines: ${oldWidget.polylines.length} -> ${widget.polylines.length}');

      // Si hay nuevos markers, centrar el mapa en la ruta
      if (widget.markers.isNotEmpty && widget.polylines.isNotEmpty) {
        _fitMapToRoute();
      }
    }
  }

  // ✅ NUEVA FUNCIÓN PARA AJUSTAR EL MAPA A LA RUTA
  Future<void> _fitMapToRoute() async {
    if (widget.markers.isEmpty) return;

    try {
      final controller = await _mapController.future;

      // Calcular bounds para incluir todos los markers
      double minLat = widget.markers.first.position.latitude;
      double maxLat = widget.markers.first.position.latitude;
      double minLng = widget.markers.first.position.longitude;
      double maxLng = widget.markers.first.position.longitude;

      for (final marker in widget.markers) {
        minLat = math.min(minLat, marker.position.latitude);
        maxLat = math.max(maxLat, marker.position.latitude);
        minLng = math.min(minLng, marker.position.longitude);
        maxLng = math.max(maxLng, marker.position.longitude);
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      print('🎯 Ajustando mapa a bounds: $bounds');

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          100.0, // padding
        ),
      );
    } catch (e) {
      print('❌ Error ajustando mapa a ruta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        print('🗺️ MapViewWidget - Estado cambiado: ${state.runtimeType}');

        // Escuchar cuando necesita centrar el mapa en una posición específica
        if (state is LoadedState && state.centerPosition != null) {
          _centerMapOnPosition(state.centerPosition!);
        }

        // ✅ NUEVA LÓGICA PARA MANEJAR RUTAS
        if (state is LoadedState &&
            state.markers.isNotEmpty &&
            state.polylines.isNotEmpty) {
          print('🛣️ Nueva ruta cargada, ajustando vista del mapa');
          _fitMapToRoute();
        }
      },
      child: GoogleMap(
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          print('🗺️ Mapa creado exitosamente');
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
          print('📍 Tap en mapa: $position');
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