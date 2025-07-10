import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/carpool.dart';
import '../../../domain/entities/route.dart';
import '../../../domain/entities/route_carpool.dart';

class WaitingCarpoolState extends Equatable {
  final bool isLoadingCarpool;
  final bool isLoadingRoute;
  final bool isStartingCarpool;
  final bool isCancellingCarpool;
  final Carpool? carpool;
  final RouteCarpool? routeCarpool;
  final Route? route;
  final List<LatLng>? routeCoordinates;
  final String? errorMessage;
  final String? successMessage;
  final LatLng? userLocation;

  const WaitingCarpoolState({
    this.isLoadingCarpool = false,
    this.isLoadingRoute = false,
    this.isStartingCarpool = false,
    this.isCancellingCarpool = false,
    this.carpool,
    this.routeCarpool,
    this.route,
    this.routeCoordinates,
    this.errorMessage,
    this.successMessage,
    this.userLocation,
  });

  bool get hasCarpool => carpool != null;
  bool get hasRoute => route != null && routeCoordinates != null;
  bool get isLoading => isLoadingCarpool || isLoadingRoute || isStartingCarpool || isCancellingCarpool;

  WaitingCarpoolState copyWith({
    bool? isLoadingCarpool,
    bool? isLoadingRoute,
    bool? isStartingCarpool,
    bool? isCancellingCarpool,
    Carpool? carpool,
    RouteCarpool? routeCarpool,
    Route? route,
    List<LatLng>? routeCoordinates,
    String? errorMessage,
    String? successMessage,
    LatLng? userLocation,
  }) {
    return WaitingCarpoolState(
      isLoadingCarpool: isLoadingCarpool ?? this.isLoadingCarpool,
      isLoadingRoute: isLoadingRoute ?? this.isLoadingRoute,
      isStartingCarpool: isStartingCarpool ?? this.isStartingCarpool,
      isCancellingCarpool: isCancellingCarpool ?? this.isCancellingCarpool,
      carpool: carpool ?? this.carpool,
      routeCarpool: routeCarpool ?? this.routeCarpool,
      route: route ?? this.route,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
      errorMessage: errorMessage,
      successMessage: successMessage,
      userLocation: userLocation ?? this.userLocation,
    );
  }

  WaitingCarpoolState clearMessages() {
    return copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingCarpool,
    isLoadingRoute,
    isStartingCarpool,
    isCancellingCarpool,
    carpool,
    routeCarpool,
    route,
    routeCoordinates,
    errorMessage,
    successMessage,
    userLocation,
  ];
}