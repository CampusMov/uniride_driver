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