import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatId;
  final String carpoolId;
  final String driverId;
  final String passengerId;
  final String createdAt;
  final String lastMessageAt;
  final String status;
  final String lastMessagePreview;
  final int unreadCount;

  const Chat({
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

  @override
  List<Object?> get props => [
    chatId,
    carpoolId,
    driverId,
    passengerId,
    createdAt,
    lastMessageAt,
    status,
    lastMessagePreview,
    unreadCount,
  ];
}