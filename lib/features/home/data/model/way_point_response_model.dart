import 'package:uniride_driver/features/shared/domain/entities/location.dart';

import '../../domain/entities/way_point.dart';

class WayPointResponseModel {
  final String? id;
  final String? passengerId;
  final String? locationName;
  final String? locationAddress;
  final double? locationLongitude;
  final double? locationLatitude;
  final String? estimatedArrivalTime;
  final String? realArrivalTime;

  const WayPointResponseModel({
    this.id,
    this.passengerId,
    this.locationName,
    this.locationAddress,
    this.locationLongitude,
    this.locationLatitude,
    this.estimatedArrivalTime,
    this.realArrivalTime,
  });

  factory WayPointResponseModel.fromJson(Map<String, dynamic> json) {
    return WayPointResponseModel(
      id: json['id'],
      passengerId: json['passengerId'],
      locationName: json['locationName'],
      locationAddress: json['locationAddress'],
      locationLongitude: (json['locationLongitude'] as num?)?.toDouble(),
      locationLatitude: (json['locationLatitude'] as num?)?.toDouble(),
      estimatedArrivalTime: json['estimatedArrivalTime'],
      realArrivalTime: json['realArrivalTime'],
    );
  }

  WayPoint toDomain() {
    return WayPoint(
      id: id ?? '',
      passengerId: passengerId ?? '',
      location: Location(
        name: locationName ?? '',
        address: locationAddress ?? '',
        longitude: locationLongitude ?? 0.0,
        latitude: locationLatitude ?? 0.0,
      ),
      estimatedArrivalTime: estimatedArrivalTime != null
          ? DateTime.parse(estimatedArrivalTime!)
          : null,
      realArrivalTime: realArrivalTime != null
          ? DateTime.parse(realArrivalTime!)
          : null,
    );
  }

}