import '../../../shared/domain/entities/location.dart';

class RouteCarpoolUpdateCurrentLocationRequestModel {
  final double latitude;
  final double longitude;

  RouteCarpoolUpdateCurrentLocationRequestModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory RouteCarpoolUpdateCurrentLocationRequestModel.fromDomain(Location location) {
    return RouteCarpoolUpdateCurrentLocationRequestModel(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }
}