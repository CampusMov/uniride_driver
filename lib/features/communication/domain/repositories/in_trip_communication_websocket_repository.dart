import '../entities/message.dart';

abstract class InTripCommunicationWebSocketRepository {
  Future<void> connectSession();
  Stream<Message> subscribeToChat(String chatId);
  Future<void> sendMessage(String chatId, String senderId, String content);
  Future<void> disconnectSession();
  Future<void> awaitConnectionReady();
}
