import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/resource.dart';
import '../../../../core/websocket/websocket_manager.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../../core/events/app_events.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/in_trip_communication_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final InTripCommunicationRepository _repository;
  final UserRepository _userRepository;
  final WebSocketManager _webSocketManager;
  late StreamSubscription _messageSubscription;

  ChatBloc({
    required InTripCommunicationRepository repository,
    required UserRepository userRepository,
    WebSocketManager? webSocketManager,
  }) : _repository = repository,
        _userRepository = userRepository,
        _webSocketManager = webSocketManager ?? WebSocketManager(),
        super(const ChatState()) {

    on<InitializeChat>(_onInitializeChat);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
    on<CloseChat>(_onCloseChat);
    on<RetryGetChat>(_onRetryGetChat);

    // Listen to WebSocket message events
    _messageSubscription = AppEventBus().on<ChatMessageReceived>().listen((event) {
      if (state.chat != null && event.chatId == state.chat!.chatId) {
        add(MessageReceived(event.message));
      }
    });
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    if (state.chat != null) {
      _webSocketManager.unsubscribeFromChatMessages(state.chat!.chatId);
    }
    return super.close();
  }

  Future<void> _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) async {
    log('TAG: ChatBloc: Initializing chat for passenger: ${event.passengerId}, carpool: ${event.carpoolId}');

    emit(state.copyWith(
      status: ChatStatus.loadingChat,
      passengerId: event.passengerId,
      carpoolId: event.carpoolId,
      retryCount: 0,
    ));

    // Load current user
    try {
      final user = await _userRepository.getUserLocally();
      if (user == null) {
        emit(state.copyWith(
          status: ChatStatus.error,
          errorMessage: 'Usuario no encontrado',
        ));
        return;
      }

      emit(state.copyWith(currentUserId: user.id));
      log('TAG: ChatBloc: Current user loaded: ${user.id}');
    } catch (e) {
      log('TAG: ChatBloc: Error loading user: $e');
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Error cargando usuario: $e',
      ));
      return;
    }

    // Get passenger chat
    await _getPassengerChat(event.passengerId, event.carpoolId, emit);
  }

  Future<void> _getPassengerChat(String passengerId, String carpoolId, Emitter<ChatState> emit) async {
    try {
      final result = await _repository.getPassengerChat(
        passengerId: passengerId,
        carpoolId: carpoolId,
      );

      switch (result) {
        case Success():
          log('TAG: ChatBloc: Chat loaded successfully: ${result.data.chatId}');
          emit(state.copyWith(
            status: ChatStatus.chatLoaded,
            chat: result.data,
            isInitialized: true,
          ));

          // Subscribe to WebSocket for real-time messages
          _webSocketManager.subscribeToChatMessages(result.data.chatId);
          log('TAG: ChatBloc: Subscribed to WebSocket for chat: ${result.data.chatId}');

          // Load existing messages
          add(const LoadMessages());
          break;

        case Failure():
          log('TAG: ChatBloc: Failed to get chat: ${result.message}');

          // Retry logic with exponential backoff
          if (state.retryCount < 3) {
            final retryDelay = Duration(seconds: (state.retryCount + 1) * 2);
            log('TAG: ChatBloc: Retrying in ${retryDelay.inSeconds} seconds... (attempt ${state.retryCount + 1})');

            emit(state.copyWith(retryCount: state.retryCount + 1));

            await Future.delayed(retryDelay);
            add(const RetryGetChat());
          } else {
            emit(state.copyWith(
              status: ChatStatus.error,
              errorMessage: 'No se pudo obtener el chat: ${result.message}',
            ));
          }
          break;
      }
    } catch (e) {
      log('TAG: ChatBloc: Error getting passenger chat: $e');
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Error obteniendo chat: $e',
      ));
    }
  }

  Future<void> _onRetryGetChat(RetryGetChat event, Emitter<ChatState> emit) async {
    if (state.passengerId != null && state.carpoolId != null) {
      emit(state.copyWith(status: ChatStatus.loadingChat));
      await _getPassengerChat(state.passengerId!, state.carpoolId!, emit);
    }
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    if (state.chat == null) return;

    emit(state.copyWith(status: ChatStatus.loadingMessages));

    try {
      final result = await _repository.getMessages(chatId: state.chat!.chatId);

      switch (result) {
        case Success():
          log('TAG: ChatBloc: Messages loaded successfully: ${result.data.length} messages');
          emit(state.copyWith(
            status: ChatStatus.messagesLoaded,
            messages: result.data,
          ));
          break;

        case Failure():
          log('TAG: ChatBloc: Failed to load messages: ${result.message}');
          emit(state.copyWith(
            status: ChatStatus.error,
            errorMessage: 'Error cargando mensajes: ${result.message}',
            messages: [], // Keep empty list on error
          ));
          break;
      }
    } catch (e) {
      log('TAG: ChatBloc: Error loading messages: $e');
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Error cargando mensajes: $e',
        messages: [],
      ));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state.chat == null || state.currentUserId == null || event.content.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(status: ChatStatus.sendingMessage));

    try {
      // Send via WebSocket for immediate delivery
      await _webSocketManager.sendMessageChat(
        chatId: state.chat!.chatId,
        senderId: state.currentUserId!,
        content: event.content.trim(),
      );

      log('TAG: ChatBloc: Message sent via WebSocket successfully');

      // Reset to messages loaded status
      emit(state.copyWith(status: ChatStatus.messagesLoaded));

    } catch (e) {
      log('TAG: ChatBloc: Error sending message: $e');

      // Try sending via REST as fallback
      try {
        final result = await _repository.sendMessage(
          chatId: state.chat!.chatId,
          senderId: state.currentUserId!,
          content: event.content.trim(),
        );

        switch (result) {
          case Success():
            log('TAG: ChatBloc: Message sent via REST fallback successfully');
            // Add message to local list
            final newMessages = List<Message>.from(state.messages)..add(result.data);
            emit(state.copyWith(
              status: ChatStatus.messagesLoaded,
              messages: newMessages,
            ));
            break;

          case Failure():
            log('TAG: ChatBloc: Failed to send message via REST: ${result.message}');
            emit(state.copyWith(
              status: ChatStatus.error,
              errorMessage: 'Error enviando mensaje: ${result.message}',
            ));
            break;
        }
      } catch (restError) {
        log('TAG: ChatBloc: REST fallback also failed: $restError');
        emit(state.copyWith(
          status: ChatStatus.error,
          errorMessage: 'Error enviando mensaje: $restError',
        ));
      }
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    log('TAG: ChatBloc: Message received: ${event.message.content}');

    // Check if message is not already in the list (avoid duplicates)
    final messageExists = state.messages.any((msg) => msg.messageId == event.message.messageId);

    if (!messageExists) {
      final newMessages = List<Message>.from(state.messages)..add(event.message);
      emit(state.copyWith(messages: newMessages));

      // Mark as read if it's not from current user
      if (event.message.senderId != state.currentUserId) {
        add(MarkMessageAsRead(event.message.messageId));
      }
    }
  }

  Future<void> _onMarkMessageAsRead(MarkMessageAsRead event, Emitter<ChatState> emit) async {
    if (state.chat == null || state.currentUserId == null) return;

    try {
      await _repository.markMessageAsRead(
        chatId: state.chat!.chatId,
        messageId: event.messageId,
        readerId: state.currentUserId!,
      );
      log('TAG: ChatBloc: Message marked as read: ${event.messageId}');
    } catch (e) {
      log('TAG: ChatBloc: Error marking message as read: $e');
      // Don't emit error for this, it's not critical
    }
  }

  void _onCloseChat(CloseChat event, Emitter<ChatState> emit) {
    log('TAG: ChatBloc: Closing chat');

    if (state.chat != null) {
      _webSocketManager.unsubscribeFromChatMessages(state.chat!.chatId);
    }

    emit(state.copyWith(
      status: ChatStatus.closed,
      isInitialized: false,
    ));
  }
}