import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../domain/services/in_trip_communication_service.dart';
import '../models/chat_response_model.dart';
import '../models/message_response_model.dart';
import '../models/create_chat_request_model.dart';
import '../models/send_message_request_model.dart';
import '../models/mark_message_read_request_model.dart';

class InTripCommunicationServiceImpl implements InTripCommunicationService {
  final http.Client client;
  final String baseUrl;

  InTripCommunicationServiceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<void> closeChat(String chatId) async {
    final uri = Uri.parse('$baseUrl/in-trip-communication-service/chats/$chatId/close');

    final response = await client.post(uri);

    if (response.statusCode != 200) {
      log('TAG: InTripCommunicationServiceImpl: Error closing chat: ${response.body}');
      throw Exception('Error closing chat: ${response.body}');
    }
  }

  @override
  Future<ChatResponseModel> getPassengerChat(String passengerId, String carpoolId) async {
    final uri = Uri.parse('$baseUrl/in-trip-communication-service/chats/passenger/$passengerId/ride/$carpoolId');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return ChatResponseModel.fromJson(jsonDecode(response.body));
    } else {
      log('TAG: InTripCommunicationServiceImpl: Error getting passenger chat: ${response.body}');
      throw Exception('Error getting passenger chat: ${response.body}');
    }
  }

  @override
  Future<List<ChatResponseModel>> getDriverChats(String driverId) async {
    final uri = Uri.parse('$baseUrl/in-trip-communication-service/chats/driver/$driverId');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ChatResponseModel.fromJson(json)).toList();
    } else {
      log('TAG: InTripCommunicationServiceImpl: Error getting driver chats: ${response.body}');
      throw Exception('Error getting driver chats: ${response.body}');
    }
  }

  @override
  Future<List<MessageResponseModel>> getMessages(String chatId) async {
    final uri = Uri.parse('$baseUrl/in-trip-communication-service/chats/$chatId/messages');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => MessageResponseModel.fromJson(json)).toList();
    } else {
      log('TAG: InTripCommunicationServiceImpl: Error getting messages: ${response.body}');
      throw Exception('Error getting messages: ${response.body}');
    }
  }

  @override
  Future<MessageResponseModel> sendMessage(String chatId, SendMessageRequestModel request) async {
    final uri = Uri.parse('$baseUrl/in-trip-communication-service/chats/$chatId/messages');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return MessageResponseModel.fromJson(jsonDecode(response.body));
    } else {
      log('TAG: InTripCommunicationServiceImpl: Error sending message: ${response.body}');
      throw Exception('Error sending message: ${response.body}');
    }
  }

  @override
  Future<void> markMessageAsRead(String chatId, String messageId, MarkMessageReadRequestModel request) async {
    final uri = Uri.parse('$baseUrl/in-trip-communication-service/chats/$chatId/messages/$messageId/read');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      log('TAG: InTripCommunicationServiceImpl: Error marking message as read: ${response.body}');
      throw Exception('Error marking message as read: ${response.body}');
    }
  }
}