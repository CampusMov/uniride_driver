import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [name, latitude, longitude, address];
}