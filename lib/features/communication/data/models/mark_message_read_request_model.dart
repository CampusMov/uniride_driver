class MarkMessageReadRequestModel {
  final String readerId;
  final String readAt;

  const MarkMessageReadRequestModel({
    required this.readerId,
    required this.readAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'readerId': readerId,
      'readAt': readAt,
    };
  }
}