import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../domain/entities/message.dart';
import '../../bloc/chat_bloc.dart';
import '../../bloc/chat_event.dart';
import '../../bloc/chat_state.dart';

class ChatDialog extends StatefulWidget {
  final String passengerId;
  final String carpoolId;
  final String passengerName;

  const ChatDialog({
    super.key,
    required this.passengerId,
    required this.carpoolId,
    required this.passengerName,
  });

  static Future<void> show(
      BuildContext context, {
        required String passengerId,
        required String carpoolId,
        required String passengerName,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => BlocProvider(
        create: (context) => di.sl<ChatBloc>()
          ..add(InitializeChat(
            passengerId: passengerId,
            carpoolId: carpoolId,
          )),
        child: ChatDialog(
          passengerId: passengerId,
          carpoolId: carpoolId,
          passengerName: passengerName,
        ),
      ),
    );
  }

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Auto-focus on message input when keyboard appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(content));
      _messageController.clear();

      // Scroll to bottom after sending
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        // Scroll to bottom when new messages arrive
        if (state.status == ChatStatus.messagesLoaded) {
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        }

        // Show error messages
        if (state.status == ChatStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildHeader(context, state),
                Expanded(child: _buildContent(context, state)),
                _buildMessageInput(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ChatState state) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              context.read<ChatBloc>().add(const CloseChat());
              Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Passenger info
          Expanded(
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.passengerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getStatusText(state),
                        style: TextStyle(
                          color: _getStatusColor(state),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Connection status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getConnectionColor(state),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ChatState state) {
    if (state.status == ChatStatus.loadingChat) {
      return _buildLoadingState('Conectando al chat...');
    }

    if (state.status == ChatStatus.loadingMessages) {
      return _buildLoadingState('Cargando mensajes...');
    }

    if (state.status == ChatStatus.error) {
      return _buildErrorState(state);
    }

    if (state.messages.isEmpty) {
      return _buildEmptyState();
    }

    return _buildMessagesList(context, state);
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ChatState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Error de conexión',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.errorMessage ?? 'Error desconocido',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<ChatBloc>().add(const RetryGetChat());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Aún no hay mensajes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¡Envía el primer mensaje!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, ChatState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          final isCurrentUser = message.senderId == state.currentUserId;
          final showTimestamp = _shouldShowTimestamp(state.messages, index);

          return Column(
            children: [
              if (showTimestamp) _buildTimestamp(message.sentAt),
              _buildMessageBubble(message, isCurrentUser),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimestamp(String sentAt) {
    // Parse and format timestamp
    try {
      final dateTime = DateTime.parse(sentAt);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      String timeText;
      if (messageDate == today) {
        timeText = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        timeText = '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          timeText,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildMessageBubble(Message message, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            // Other user avatar
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.orange,
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? Colors.orange
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                  bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
          ),

          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            // Current user avatar
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.blue,
                size: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatState state) {
    final canSend = state.status == ChatStatus.messagesLoaded ||
        state.status == ChatStatus.chatLoaded;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3F4042),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                enabled: canSend,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: canSend ? 'Escribe un mensaje...' : 'Conectando...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: canSend ? (_) => _sendMessage() : null,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Send button
          GestureDetector(
            onTap: canSend ? _sendMessage : null,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: canSend ? Colors.orange : Colors.grey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: state.status == ChatStatus.sendingMessage
                  ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
                  : const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(List<Message> messages, int index) {
    if (index == 0) return true;

    try {
      final currentMessage = messages[index];
      final previousMessage = messages[index - 1];

      final currentTime = DateTime.parse(currentMessage.sentAt);
      final previousTime = DateTime.parse(previousMessage.sentAt);

      // Show timestamp if more than 5 minutes apart
      return currentTime.difference(previousTime).inMinutes > 5;
    } catch (e) {
      return false;
    }
  }

  String _getStatusText(ChatState state) {
    switch (state.status) {
      case ChatStatus.loadingChat:
        return 'Conectando...';
      case ChatStatus.loadingMessages:
        return 'Cargando mensajes...';
      case ChatStatus.sendingMessage:
        return 'Enviando...';
      case ChatStatus.messagesLoaded:
      case ChatStatus.chatLoaded:
        return 'En línea';
      case ChatStatus.error:
        return 'Error de conexión';
      case ChatStatus.closed:
        return 'Desconectado';
      default:
        return 'Conectando...';
    }
  }

  Color _getStatusColor(ChatState state) {
    switch (state.status) {
      case ChatStatus.messagesLoaded:
      case ChatStatus.chatLoaded:
        return Colors.green;
      case ChatStatus.error:
        return Colors.red;
      case ChatStatus.loadingChat:
      case ChatStatus.loadingMessages:
      case ChatStatus.sendingMessage:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getConnectionColor(ChatState state) {
    switch (state.status) {
      case ChatStatus.messagesLoaded:
      case ChatStatus.chatLoaded:
        return Colors.green;
      case ChatStatus.error:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}