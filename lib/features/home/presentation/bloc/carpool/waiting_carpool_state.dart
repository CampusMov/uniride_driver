import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/carpool.dart';
import '../../../domain/entities/route.dart';

class WaitingCarpoolState extends Equatable {
  final bool isLoadingCarpool;
  final bool isLoadingRoute;
  final bool isStartingCarpool;
  final bool isCancellingCarpool;
  final Carpool? carpool;
  final Route? route;
  final List<LatLng>? routeCoordinates;
  final String? errorMessage;
  final String? successMessage;

  const WaitingCarpoolState({
    this.isLoadingCarpool = false,
    this.isLoadingRoute = false,
    this.isStartingCarpool = false,
    this.isCancellingCarpool = false,
    this.carpool,
    this.route,
    this.routeCoordinates,
    this.errorMessage,
    this.successMessage,
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
    Route? route,
    List<LatLng>? routeCoordinates,
    String? errorMessage,
    String? successMessage,
  }) {
    return WaitingCarpoolState(
      isLoadingCarpool: isLoadingCarpool ?? this.isLoadingCarpool,
      isLoadingRoute: isLoadingRoute ?? this.isLoadingRoute,
      isStartingCarpool: isStartingCarpool ?? this.isStartingCarpool,
      isCancellingCarpool: isCancellingCarpool ?? this.isCancellingCarpool,
      carpool: carpool ?? this.carpool,
      route: route ?? this.route,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
      errorMessage: errorMessage,
      successMessage: successMessage,
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
    route,
    routeCoordinates,
    errorMessage,
    successMessage,
  ];
}