class SendMessageRequestModel {
  final String chatId;
  final String senderId;
  final String content;

  const SendMessageRequestModel({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
    };
  }
}