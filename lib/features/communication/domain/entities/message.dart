import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String messageId;
  final String senderId;
  final String content;
  final String sentAt;
  final String status;

  const Message({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
    messageId,
    senderId,
    content,
    sentAt,
    status,
  ];
}

// create_chat_request_model.dart
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