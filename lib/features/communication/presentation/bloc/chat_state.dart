import 'package:equatable/equatable.dart';

import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

enum ChatStatus {
  initial,
  loadingChat,
  chatLoaded,
  loadingMessages,
  messagesLoaded,
  sendingMessage,
  error,
  closed,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final Chat? chat;
  final List<Message> messages;
  final String? errorMessage;
  final bool isInitialized;
  final String? passengerId;
  final String? carpoolId;
  final String? currentUserId;
  final int retryCount;

  const ChatState({
    this.status = ChatStatus.initial,
    this.chat,
    this.messages = const [],
    this.errorMessage,
    this.isInitialized = false,
    this.passengerId,
    this.carpoolId,
    this.currentUserId,
    this.retryCount = 0,
  });

  ChatState copyWith({
    ChatStatus? status,
    Chat? chat,
    List<Message>? messages,
    String? errorMessage,
    bool? isInitialized,
    String? passengerId,
    String? carpoolId,
    String? currentUserId,
    int? retryCount,
  }) {
    return ChatState(
      status: status ?? this.status,
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
      passengerId: passengerId ?? this.passengerId,
      carpoolId: carpoolId ?? this.carpoolId,
      currentUserId: currentUserId ?? this.currentUserId,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    chat,
    messages,
    errorMessage,
    isInitialized,
    passengerId,
    carpoolId,
    currentUserId,
    retryCount,
  ];
}