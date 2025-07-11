import '../../../../core/utils/resource.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class InTripCommunicationRepository {
  Future<Resource<Chat>> createChat({
    required String carpoolId,
    required String driverId,
    required String passengerId,
  });

  Future<Resource<void>> closeChat({required String chatId});

  Future<Resource<Chat>> getPassengerChat({
    required String passengerId,
    required String carpoolId,
  });

  Future<Resource<List<Chat>>> getDriverChats({required String driverId});

  Future<Resource<List<Message>>> getMessages({required String chatId});

  Future<Resource<Message>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  });

  Future<Resource<void>> markMessageAsRead({
    required String chatId,
    required String messageId,
    required String readerId,
  });
}