import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uniride_driver/core/constants/api_constants.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key, required this.markers, required this.polylines});

  //Varibles que necesita el widget
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  



  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
  
}

class _MapViewWidgetState extends State<MapViewWidget> {



  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  LocationData? _currentLocation;
  final Location location = Location();

  
    final _initialCameraPosition =CameraPosition(
      target:LatLng(0, 0),
      zoom: 1,
    );
    
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
                    onTap:(position){
                     
                      
                    },
                  );
          
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verifica que el GPS esté habilitado
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Verifica permisos
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
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


