import 'package:equatable/equatable.dart';

import '../../../shared/domain/entities/location.dart';
import 'enum_passenger_request_status.dart';

class PassengerRequest extends Equatable {
  final String id;
  final String carpoolId;
  final String passengerId;
  final Location pickupLocation;
  final PassengerRequestStatus status;
  final int requestedSeats;

  const PassengerRequest({
    this.id = '1',
    required this.carpoolId,
    required this.passengerId,
    required this.pickupLocation,
    required this.status,
    required this.requestedSeats,
  });

  @override
  List<Object?> get props => [
    id,
    carpoolId,
    passengerId,
    pickupLocation,
    status,
    requestedSeats,
  ];
}