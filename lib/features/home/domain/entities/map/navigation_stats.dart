import 'package:equatable/equatable.dart';

class NavigationStats extends Equatable {
  final double totalDistance;
  final int waypoints;
  final bool isActive;

  const NavigationStats({
    required this.totalDistance,
    required this.waypoints,
    required this.isActive,
  });

  static const NavigationStats empty = NavigationStats(
    totalDistance: 0.0,
    waypoints: 0,
    isActive: false,
  );

  String get formattedDistance {
    if (totalDistance < 1000) {
      return '${totalDistance.toStringAsFixed(0)} m';
    } else {
      return '${(totalDistance / 1000).toStringAsFixed(1)} km';
    }
  }

  @override
  List<Object?> get props => [totalDistance, waypoints, isActive];
}