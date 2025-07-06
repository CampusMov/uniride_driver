class LocationRequestModel {
  final String name;
  final String address;
  final double longitude;
  final double latitude;

  const LocationRequestModel({
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  factory LocationRequestModel.fromDomain(location) {
    return LocationRequestModel(
      name: location.name,
      address: location.address,
      longitude: location.longitude,
      latitude: location.latitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}