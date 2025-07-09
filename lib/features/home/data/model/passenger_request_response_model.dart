import 'package:uniride_driver/features/home/domain/entities/enum_passenger_request_status.dart';
import 'package:uniride_driver/features/home/domain/entities/passenger_request.dart';

import '../../../shared/domain/entities/location.dart';

class PassengerRequestResponseModel {
  final String id;
  final String carpoolId;
  final String passengerId;
  final String pickupLocationName;
  final String pickupLocationAddress;
  final String status;
  final int requestedSeats;

  const PassengerRequestResponseModel({
    required this.id,
    required this.carpoolId,
    required this.passengerId,
    required this.pickupLocationName,
    required this.pickupLocationAddress,
    required this.status,
    required this.requestedSeats,
  });

  factory PassengerRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return PassengerRequestResponseModel(
      id: json['id'] ?? '',
      carpoolId: json['carpoolId'] ?? '',
      passengerId: json['passengerId'] ?? '',
      pickupLocationName: json['pickupLocationName'] ?? '',
      pickupLocationAddress: json['pickupLocationAddress'] ?? '',
      status: json['status'] ?? '',
      requestedSeats: json['requestedSeats'] ?? 0,
    );
  }

  PassengerRequest toDomain() {
    return PassengerRequest(
      id: id,
      carpoolId: carpoolId,
      passengerId: passengerId,
      status: PassengerRequestStatus.fromString(status),
      requestedSeats: requestedSeats,
      pickupLocation: Location(
        name: pickupLocationName,
        address: pickupLocationAddress,
      ),
    );
  }
}