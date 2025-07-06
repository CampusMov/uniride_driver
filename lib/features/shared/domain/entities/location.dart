import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    this.name = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.address = '',
  });

  @override
  List<Object?> get props => [name, latitude, longitude, address];
}