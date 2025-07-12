import 'dart:developer';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/in_trip_communication_repository.dart';
import '../../domain/services/in_trip_communication_service.dart';
import '../models/create_chat_request_model.dart';
import '../models/mark_message_read_request_model.dart';
import '../models/send_message_request_model.dart';

class InTripCommunicationRepositoryImpl implements InTripCommunicationRepository {
  final InTripCommunicationService inTripCommunicationService;

  InTripCommunicationRepositoryImpl({required this.inTripCommunicationService});

  @override
  Future<Resource<Chat>> createChat({
    required String carpoolId,
    required String driverId,
    required String passengerId,
  }) async {
    try {
      final result = await inTripCommunicationService.createChat(
        CreateChatRequestModel(
          carpoolId: carpoolId,
          driverId: driverId,
          passengerId: passengerId,
        ),
      );
      log('TAG: InTripCommunicationRepositoryImpl: Chat created successfully for carpool: $carpoolId');
      return Success(result.toDomain());
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error creating chat: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<void>> closeChat({required String chatId}) async {
    try {
      await inTripCommunicationService.closeChat(chatId);
      log('TAG: InTripCommunicationRepositoryImpl: Chat closed successfully: $chatId');
      return const Success(null);
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error closing chat: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<Chat>> getPassengerChat({
    required String passengerId,
    required String carpoolId,
  }) async {
    try {
      final result = await inTripCommunicationService.getPassengerChat(passengerId, carpoolId);
      log('TAG: InTripCommunicationRepositoryImpl: Passenger chat fetched successfully for passenger: $passengerId');
      return Success(result.toDomain());
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error fetching passenger chat: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<List<Chat>>> getDriverChats({required String driverId}) async {
    try {
      final result = await inTripCommunicationService.getDriverChats(driverId);
      final chats = result.map((chatModel) => chatModel.toDomain()).toList();
      log('TAG: InTripCommunicationRepositoryImpl: Driver chats fetched successfully for driver: $driverId');
      return Success(chats);
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error fetching driver chats: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<List<Message>>> getMessages({required String chatId}) async {
    try {
      final result = await inTripCommunicationService.getMessages(chatId);
      final messages = result.map((messageModel) => messageModel.toDomain()).toList();
      log('TAG: InTripCommunicationRepositoryImpl: Messages fetched successfully for chat: $chatId');
      return Success(messages);
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error fetching messages: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<Message>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    try {
      final result = await inTripCommunicationService.sendMessage(
        chatId,
        SendMessageRequestModel(
          chatId: chatId,
          senderId: senderId,
          content: content,
        ),
      );
      log('TAG: InTripCommunicationRepositoryImpl: Message sent successfully in chat: $chatId');
      return Success(result.toDomain());
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error sending message: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<void>> markMessageAsRead({
    required String chatId,
    required String messageId,
    required String readerId,
  }) async {
    try {
      final nowIso = DateTime.now().toUtc().toIso8601String();
      await inTripCommunicationService.markMessageAsRead(
        chatId,
        messageId,
        MarkMessageReadRequestModel(
          readerId: readerId,
          readAt: nowIso,
        ),
      );
      log('TAG: InTripCommunicationRepositoryImpl: Message marked as read successfully: $messageId');
      return const Success(null);
    } catch (e) {
      log('TAG: InTripCommunicationRepositoryImpl: Error marking message as read: $e');
      return Failure(e.toString());
    }
  }
}
