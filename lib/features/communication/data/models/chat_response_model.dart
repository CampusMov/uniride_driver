import '../../domain/entities/chat.dart';

class ChatResponseModel {
  final String chatId;
  final String carpoolId;
  final String driverId;
  final String passengerId;
  final String createdAt;
  final String lastMessageAt;
  final String status;
  final String lastMessagePreview;
  final int unreadCount;

  const ChatResponseModel({
    required this.chatId,
    required this.carpoolId,
    required this.driverId,
    required this.passengerId,
    required this.createdAt,
    required this.lastMessageAt,
    required this.status,
    required this.lastMessagePreview,
    required this.unreadCount,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      chatId: json['chatId'] ?? '',
      carpoolId: json['carpoolId'] ?? '',
      driverId: json['driverId'] ?? '',
      passengerId: json['passengerId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      lastMessageAt: json['lastMessageAt'] ?? '',
      status: json['status'] ?? '',
      lastMessagePreview: json['lastMessagePreview'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Chat toDomain() {
    return Chat(
      chatId: chatId,
      carpoolId: carpoolId,
      driverId: driverId,
      passengerId: passengerId,
      createdAt: createdAt,
      lastMessageAt: lastMessageAt,
      status: status,
      lastMessagePreview: lastMessagePreview,
      unreadCount: unreadCount,
    );
  }
}