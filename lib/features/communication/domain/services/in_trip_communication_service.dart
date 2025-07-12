import '../../data/models/chat_response_model.dart';
import '../../data/models/create_chat_request_model.dart';
import '../../data/models/mark_message_read_request_model.dart';
import '../../data/models/message_response_model.dart';
import '../../data/models/send_message_request_model.dart';

abstract class InTripCommunicationService {
  Future<void> closeChat(String chatId);
  Future<ChatResponseModel> getPassengerChat(String passengerId, String carpoolId);
  Future<List<ChatResponseModel>> getDriverChats(String driverId);
  Future<List<MessageResponseModel>> getMessages(String chatId);
  Future<MessageResponseModel> sendMessage(String chatId, SendMessageRequestModel request);
  Future<void> markMessageAsRead(String chatId, String messageId, MarkMessageReadRequestModel request);
}