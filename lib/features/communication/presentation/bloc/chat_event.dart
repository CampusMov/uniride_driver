import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChat extends ChatEvent {
  final String passengerId;
  final String carpoolId;

  const InitializeChat({
    required this.passengerId,
    required this.carpoolId,
  });

  @override
  List<Object?> get props => [passengerId, carpoolId];
}

class LoadMessages extends ChatEvent {
  const LoadMessages();
}

class SendMessage extends ChatEvent {
  final String content;

  const SendMessage(this.content);

  @override
  List<Object?> get props => [content];
}

class MessageReceived extends ChatEvent {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class MarkMessageAsRead extends ChatEvent {
  final String messageId;

  const MarkMessageAsRead(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class CloseChat extends ChatEvent {
  const CloseChat();
}

class RetryGetChat extends ChatEvent {
  const RetryGetChat();
}