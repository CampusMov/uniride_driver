import '../../domain/entities/intersection.dart';

class IntersectionResponseModel {
  final double latitude;
  final double longitude;

  IntersectionResponseModel({
    required this.latitude,
    required this.longitude,
  });

  factory IntersectionResponseModel.fromJson(Map<String, dynamic> json) {
    return IntersectionResponseModel(
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }

  Intersection toDomain() {
    return Intersection(
      latitude: latitude,
      longitude: longitude,
    );
  }
}