import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uniride_driver/core/constants/api_constants.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key});

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
  
}

class _MapViewWidgetState extends State<MapViewWidget> {

  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng initialPosition = LatLng(-12.117642, -77.000320);
  static const LatLng finalPosition = LatLng(-12.111348, -77.000920);

  LatLng _currentPosition = LatLng(-12.118880, -77.003560);

  Map<PolylineId, Polyline> polylines = {};

 
  @override
    void initState() {
      
      super.initState();
      _getLocationUpdate().then(
        (_) => {
          _getPolyLinePoints().then((coordinates)=>{ 
            generatePolyLineFromPoint(coordinates)
          })
        }
      );
    }
    

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      initialCameraPosition: CameraPosition(
      target: initialPosition,
      zoom: 15
    ),
      cloudMapId: "388b9689db1859ee6852b722",
      markers: {
        Marker (
          markerId: MarkerId('currentLocation'),
          position: _currentPosition ,
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
        Marker(
          markerId: MarkerId('sourceLocation'),
          position: initialPosition,
          infoWindow: InfoWindow(title: 'Initial Position'),
        ),
        Marker(
          markerId: MarkerId('DestinationLocation'),
          position: finalPosition,
          infoWindow: InfoWindow(title: 'Final Position'),
        )
      },
      polylines:Set<Polyline>.of(polylines.values)
    );
  }
  Future<void> _cameraPositionUpdate(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;

    CameraPosition cameraPosition = CameraPosition(
      target: pos,
      zoom: 15,
    );
    
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );


  }

  Future<void> _getLocationUpdate() async {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await _locationController.serviceEnabled();

      if(_serviceEnabled){
        _serviceEnabled = await _locationController.requestService();
      }
      else{
        return;
      }
      _permissionGranted = await _locationController.hasPermission();
      if(_permissionGranted == PermissionStatus.denied){
        _permissionGranted = await _locationController.requestPermission();
        if(_permissionGranted != PermissionStatus.granted){
          return;
        }
      }
      _locationController.onLocationChanged
      .listen((LocationData currentLocation) {
        if(currentLocation.longitude != null && 
        currentLocation.latitude != null) {
          setState(() {
           _currentPosition = 
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraPositionUpdate(_currentPosition);
          });
        }
        
      });
    }

  Future<List<LatLng>> _getPolyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: ApiConstants.googleMapApiKey,
      request: PolylineRequest(
        origin: PointLatLng(initialPosition.latitude, initialPosition.longitude),
        destination: PointLatLng(finalPosition.latitude, finalPosition.longitude),
        mode: TravelMode.driving
      ),
      
    );
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));
      });
    } else{
      print(result.errorMessage);
    }
    return polylineCoordinates;
    }

  void generatePolyLineFromPoint(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id, 
      color: ColorPaletter.warning, 
      points: polylineCoordinates, 
      width: 8
      );
    setState(() {
      polylines[id] = polyline;
    });
  }
}