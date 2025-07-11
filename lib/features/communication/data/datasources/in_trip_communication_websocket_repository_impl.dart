import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/in_trip_communication_websocket_repository.dart';
import '../models/message_response_model.dart';
import '../models/send_message_request_model.dart';

class InTripCommunicationWebSocketRepositoryImpl implements InTripCommunicationWebSocketRepository {
  static const String _servicesWebSocketUrl = 'ws://your-websocket-url';
  static const String _inTripCommunicationServiceName = '/in-trip-communication-service';

  StompClient? _stompClient;
  final Completer<void> _sessionReady = Completer<void>();
  final Map<String, StreamController<Message>> _chatStreams = {};

  @override
  Future<void> connectSession() async {
    try {
      final endpointUrl = '$_servicesWebSocketUrl$_inTripCommunicationServiceName/ws';

      _stompClient = StompClient(
        config: StompConfig(
          url: endpointUrl,
          onConnect: (StompFrame frame) {
            log('TAG: InTripCommunicationWebSocketRepositoryImpl: Connected to WebSocket');
            if (!_sessionReady.isCompleted) {
              _sessionReady.complete();
            }
          },
          onWebSocketError: (dynamic error) {
            log('TAG: InTripCommunicationWebSocketRepositoryImpl: WebSocket error: $error');
          },
          onStompError: (StompFrame frame) {
            log('TAG: InTripCommunicationWebSocketRepositoryImpl: Stomp error: ${frame.body}');
          },
          onDisconnect: (StompFrame frame) {
            log('TAG: InTripCommunicationWebSocketRepositoryImpl: Disconnected from WebSocket');
          },
        ),
      );

      _stompClient!.activate();
      log('TAG: InTripCommunicationWebSocketRepositoryImpl: WebSocket session connection initiated');
    } catch (e) {
      log('TAG: InTripCommunicationWebSocketRepositoryImpl: Error connecting to WebSocket: $e');
      rethrow;
    }
  }

  @override
  Stream<Message> subscribeToChat(String chatId) {
    if (_chatStreams.containsKey(chatId)) {
      return _chatStreams[chatId]!.stream;
    }

    final streamController = StreamController<Message>.broadcast();
    _chatStreams[chatId] = streamController;

    awaitConnectionReady().then((_) {
      if (_stompClient == null) {
        throw Exception('WebSocket session is not connected. Call connectSession() first.');
      }

      final topicPath = '/topic/chats/$chatId';

      _stompClient!.subscribe(
        destination: topicPath,
        callback: (StompFrame frame) {
          if (frame.body != null) {
            try {
              final json = jsonDecode(frame.body!);
              final messageDto = MessageResponseModel.fromJson(json);
              final message = messageDto.toDomain();
              streamController.add(message);
              log('TAG: InTripCommunicationWebSocketRepositoryImpl: Message received in chat: $chatId');
            } catch (e) {
              log('TAG: InTripCommunicationWebSocketRepositoryImpl: Error parsing message: $e');
            }
          }
        },
      );

      log('TAG: InTripCommunicationWebSocketRepositoryImpl: Subscribed to chat: $chatId');
    }).catchError((error) {
      log('TAG: InTripCommunicationWebSocketRepositoryImpl: Error subscribing to chat: $error');
      streamController.addError(error);
    });

    return streamController.stream;
  }

  @override
  Future<void> sendMessage(String chatId, String senderId, String content) async {
    try {
      await awaitConnectionReady();

      if (_stompClient == null) {
        throw Exception('WebSocket session is not connected. Call connectSession() first.');
      }

      final messageRequest = SendMessageRequestModel(
        senderId: senderId,
        content: content,
        chatId: chatId,
      );

      final destination = '/app/chat/$chatId/send';

      _stompClient!.send(
        destination: destination,
        body: jsonEncode(messageRequest.toJson()),
      );

      log('TAG: InTripCommunicationWebSocketRepositoryImpl: Message sent via WebSocket in chat: $chatId');
    } catch (e) {
      log('TAG: InTripCommunicationWebSocketRepositoryImpl: Error sending message via WebSocket: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnectSession() async {
    try {
      _stompClient?.deactivate();
      _stompClient = null;

      // Close all stream controllers
      for (final controller in _chatStreams.values) {
        await controller.close();
      }
      _chatStreams.clear();

      log('TAG: InTripCommunicationWebSocketRepositoryImpl: WebSocket session disconnected');
    } catch (e) {
      log('TAG: InTripCommunicationWebSocketRepositoryImpl: Error disconnecting WebSocket: $e');
    }
  }

  @override
  Future<void> awaitConnectionReady() async {
    await _sessionReady.future;
  }
}