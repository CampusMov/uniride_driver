class RouteRequestModel {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  RouteRequestModel({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
    };
  }
}