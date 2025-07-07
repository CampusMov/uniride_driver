import 'package:uniride_driver/features/home/domain/entities/route.dart';

import 'intersection_response_model.dart';

class RouteResponseModel {
  final List<IntersectionResponseModel> intersections;
  final double totalDistance;
  final double totalDuration;

  const RouteResponseModel({
    required this.intersections,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory RouteResponseModel.fromJson(Map<String, dynamic> json) {
    return RouteResponseModel(
      intersections: (json['intersections'] as List)
          .map((e) => IntersectionResponseModel.fromJson(e))
          .toList(),
      totalDistance: (json['totalDistance'] ?? 0.0).toDouble(),
      totalDuration: (json['totalDuration'] ?? 0.0).toDouble(),
    );
  }

  Route toDomain() {
    return Route(
      intersections: intersections.map((e) => e.toDomain()).toList(),
      totalDistance: totalDistance,
      totalDuration: totalDuration,
    );
  }
}