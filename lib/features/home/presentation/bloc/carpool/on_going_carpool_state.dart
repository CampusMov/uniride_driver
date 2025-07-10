import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/home/domain/entities/carpool.dart';
import 'package:uniride_driver/features/home/domain/entities/route.dart';
import 'package:uniride_driver/features/home/domain/entities/route_carpool.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

class OnGoingCarpoolState extends Equatable {
  final bool isLoadingCarpool;
  final bool isLoadingRoute;
  final bool isLoadingRouteCarpool;
  final bool isLocationTracking;
  final bool isFinishingCarpool;
  final Carpool? carpool;
  final RouteCarpool? routeCarpool;
  final Route? route;
  final Location? currentLocation;
  final DateTime? lastLocationUpdate;
  final DateTime? estimatedArrivalTime;
  final String? estimatedDurationText;
  final String? estimatedDistanceText;
  final bool isNearDestination;
  final String? errorMessage;
  final String? successMessage;

  const OnGoingCarpoolState({
    this.isLoadingCarpool = false,
    this.isLoadingRoute = false,
    this.isLoadingRouteCarpool = false,
    this.isLocationTracking = false,
    this.isFinishingCarpool = false,
    this.carpool,
    this.routeCarpool,
    this.route,
    this.currentLocation,
    this.lastLocationUpdate,
    this.estimatedArrivalTime,
    this.estimatedDurationText,
    this.estimatedDistanceText,
    this.isNearDestination = false,
    this.errorMessage,
    this.successMessage,
  });

  bool get hasCarpool => carpool != null;
  bool get hasRoute => route != null;
  bool get hasRouteCarpool => routeCarpool != null;
  bool get isLoading => isLoadingCarpool || isLoadingRoute || isLoadingRouteCarpool || isFinishingCarpool;
  bool get isInitialized => hasCarpool && hasRouteCarpool;

  OnGoingCarpoolState copyWith({
    bool? isLoadingCarpool,
    bool? isLoadingRoute,
    bool? isLoadingRouteCarpool,
    bool? isLocationTracking,
    bool? isFinishingCarpool,
    Carpool? carpool,
    RouteCarpool? routeCarpool,
    Route? route,
    Location? currentLocation,
    DateTime? lastLocationUpdate,
    DateTime? estimatedArrivalTime,
    String? estimatedDurationText,
    String? estimatedDistanceText,
    bool? isNearDestination,
    String? errorMessage,
    String? successMessage,
  }) {
    return OnGoingCarpoolState(
      isLoadingCarpool: isLoadingCarpool ?? this.isLoadingCarpool,
      isLoadingRoute: isLoadingRoute ?? this.isLoadingRoute,
      isLoadingRouteCarpool: isLoadingRouteCarpool ?? this.isLoadingRouteCarpool,
      isLocationTracking: isLocationTracking ?? this.isLocationTracking,
      isFinishingCarpool: isFinishingCarpool ?? this.isFinishingCarpool,
      carpool: carpool ?? this.carpool,
      routeCarpool: routeCarpool ?? this.routeCarpool,
      route: route ?? this.route,
      currentLocation: currentLocation ?? this.currentLocation,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      estimatedArrivalTime: estimatedArrivalTime ?? this.estimatedArrivalTime,
      estimatedDurationText: estimatedDurationText ?? this.estimatedDurationText,
      estimatedDistanceText: estimatedDistanceText ?? this.estimatedDistanceText,
      isNearDestination: isNearDestination ?? this.isNearDestination,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  OnGoingCarpoolState clearMessages() {
    return copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingCarpool,
    isLoadingRoute,
    isLoadingRouteCarpool,
    isLocationTracking,
    isFinishingCarpool,
    carpool,
    routeCarpool,
    route,
    currentLocation,
    lastLocationUpdate,
    estimatedArrivalTime,
    estimatedDurationText,
    estimatedDistanceText,
    isNearDestination,
    errorMessage,
    successMessage,
  ];
}