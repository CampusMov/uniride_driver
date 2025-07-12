class CreateChatRequestModel {
  final String carpoolId;
  final String driverId;
  final String passengerId;

  const CreateChatRequestModel({
    required this.carpoolId,
    required this.driverId,
    required this.passengerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'carpoolId': carpoolId,
      'driverId': driverId,
      'passengerId': passengerId,
    };
  }
}