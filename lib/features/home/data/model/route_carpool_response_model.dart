import 'package:uniride_driver/features/home/domain/entities/route_carpool.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

class RouteCarpoolResponseModel {
  final String? id;
  final String? carpoolId;
  final String? realStartedTime;
  final String? estimatedEndedTime;
  final double? estimatedDurationMinutes;
  final double? estimatedDistanceKm;
  final String? originName;
  final String? originAddress;
  final double? originLongitude;
  final double? originLatitude;
  final String? destinationName;
  final String? destinationAddress;
  final double? destinationLongitude;
  final double? destinationLatitude;
  final String? carpoolCurrentName;
  final String? carpoolCurrentAddress;
  final double? carpoolCurrentLongitude;
  final double? carpoolCurrentLatitude;

  const RouteCarpoolResponseModel({
    this.id,
    this.carpoolId,
    this.realStartedTime,
    this.estimatedEndedTime,
    this.estimatedDurationMinutes,
    this.estimatedDistanceKm,
    this.originName,
    this.originAddress,
    this.originLongitude,
    this.originLatitude,
    this.destinationName,
    this.destinationAddress,
    this.destinationLongitude,
    this.destinationLatitude,
    this.carpoolCurrentName,
    this.carpoolCurrentAddress,
    this.carpoolCurrentLongitude,
    this.carpoolCurrentLatitude,
  });

  factory RouteCarpoolResponseModel.fromJson(Map<String, dynamic> json) {
    return RouteCarpoolResponseModel(
      id: json['id'] ?? '',
      carpoolId: json['carpoolId'] ?? '',
      realStartedTime: json['realStartedTime'] ?? '',
      estimatedEndedTime: json['estimatedEndedTime'] ?? '',
      estimatedDurationMinutes: (json['estimatedDurationMinutes'] ?? 0.0).toDouble(),
      estimatedDistanceKm: (json['estimatedDistanceKm'] ?? 0.0).toDouble(),
      originName: json['originName'] ?? '',
      originAddress: json['originAddress'] ?? '',
      originLongitude: (json['originLongitude'] ?? 0.0).toDouble(),
      originLatitude: (json['originLatitude'] ?? 0.0).toDouble(),
      destinationName: json['destinationName'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
      destinationLongitude: (json['destinationLongitude'] ?? 0.0).toDouble(),
      destinationLatitude: (json['destinationLatitude'] ?? 0.0).toDouble(),
      carpoolCurrentName: json['carpoolCurrentName'] ?? '',
      carpoolCurrentAddress: json['carpoolCurrentAddress'] ?? '',
      carpoolCurrentLongitude: (json['carpoolCurrentLongitude'] ?? 0.0).toDouble(),
      carpoolCurrentLatitude: (json['carpoolCurrentLatitude'] ?? 0.0).toDouble(),
    );
  }

  RouteCarpool toDomain() {
    return RouteCarpool(
      id: id ?? '',
      carpoolId: carpoolId ?? '',
      realStartedTime: realStartedTime != null
          ? DateTime.parse(realStartedTime!)
          : null,
      estimatedEndedTime: estimatedEndedTime != null
          ? DateTime.parse(estimatedEndedTime!)
          : null,
      estimatedDurationMinutes: estimatedDurationMinutes ?? 0.0,
      estimatedDistanceKm: estimatedDistanceKm ?? 0.0,
      origin: Location(
        name: originName ?? '',
        address: originAddress ?? '',
        longitude: originLongitude ?? 0.0,
        latitude: originLatitude ?? 0.0,
      ),
      destination: Location(
        name: destinationName ?? '',
        address: destinationAddress ?? '',
        longitude: destinationLongitude ?? 0.0,
        latitude: destinationLatitude ?? 0.0,
      ),
      carpoolCurrentLocation: Location(
        name: carpoolCurrentName ?? '',
        address: carpoolCurrentAddress ?? '',
        longitude: carpoolCurrentLongitude ?? 0.0,
        latitude: carpoolCurrentLatitude ?? 0.0,
      ),
    );
  }
}