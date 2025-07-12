import '../../domain/entities/message.dart';

class MessageResponseModel {
  final String messageId;
  final String senderId;
  final String content;
  final String sentAt;
  final String status;

  const MessageResponseModel({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.status,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      messageId: json['messageId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      sentAt: json['sentAt'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Message toDomain() {
    return Message(
      messageId: messageId,
      senderId: senderId,
      content: content,
      sentAt: sentAt,
      status: status,
    );
  }
}