class CreateLocationRequestModel {
  final String name;
  final String address;
  final double longitude;
  final double latitude;

  const CreateLocationRequestModel({
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}