import 'package:equatable/equatable.dart';

class CarpoolLocation extends Equatable {
  final String name;
  final String address;
  final double longitude;
  final double latitude;

  const CarpoolLocation({
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  @override
  List<Object?> get props => [name, address, longitude, latitude];
}