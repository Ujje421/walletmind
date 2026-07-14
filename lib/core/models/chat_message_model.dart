/// Chat message model for the AI chat interface.
class ChatMessage {
  final String id;
  final String content;
  final ChatRole role;
  final DateTime timestamp;
  final String? transactionId;
  final ChatMessageType type;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.transactionId,
    this.type = ChatMessageType.text,
  });

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;
}

enum ChatRole { user, assistant }

enum ChatMessageType {
  text,
  transactionConfirm,
  insight,
  error,
  suggestion,
}
