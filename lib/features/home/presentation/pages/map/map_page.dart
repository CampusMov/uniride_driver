import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/map/map_bloc.dart';
import '../../bloc/map/map_event.dart';
import '../../bloc/map/map_state.dart';

class MapScreen extends StatelessWidget {
  final LatLng? initialLocation;
  final double initialZoom;
  final bool showMyLocationButton;
  final bool showUserLocation;
  final bool autoGetUserLocation;
  final EdgeInsets padding;

  const MapScreen({
    super.key,
    this.initialLocation,
    this.initialZoom = 15.0,
    this.showMyLocationButton = true,
    this.autoGetUserLocation = false,
    this.showUserLocation = true,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  context.read<MapBloc>().add(MapInitialized(controller));
                  if (autoGetUserLocation) {
                    context.read<MapBloc>().add(GetUserLocation());
                  }
                },
                initialCameraPosition: CameraPosition(
                  target: initialLocation ??
                      const LatLng(-12.0464, -77.0428),
                  zoom: initialZoom,
                ),
                markers: state.markers,
                polylines: state.polylines,
                circles: state.circles,
                mapType: state.mapType,
                myLocationEnabled: showUserLocation && state.canShowUserLocation,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                padding: padding,
                onTap: (LatLng position) {
                  // Optional: to handle map taps
                  debugPrint('Map tapped at: ${position.latitude}, ${position.longitude}');
                },
                onLongPress: (LatLng position) {
                  // Optional: to handle long presses
                  debugPrint('Map long pressed at: ${position.latitude}, ${position.longitude}');
                },
                onCameraMove: (CameraPosition position) {
                  // Optional: to handle camera movements
                },
              ),

              if (showMyLocationButton)
                Positioned(
                  bottom: 30,
                  right: 16,
                  child: _buildMyLocationButton(context, state),
                ),

              if (state.isLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (state.error != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorMessage(state.error!),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMyLocationButton(BuildContext context, MapState state) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      onPressed: () {
        if (state.userLocation != null) {
          context.read<MapBloc>().add(CenterMap(state.userLocation!));
        } else {
          context.read<MapBloc>().add(GetUserLocation());
        }
      },
      child: Icon(
        state.userLocation != null
            ? Icons.my_location
            : Icons.location_searching,
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}