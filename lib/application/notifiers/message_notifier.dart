import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';

class MessageNotifier extends StateNotifier<List<ChatMessage>> {
  MessageNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void deleteMessage(String messageId) {
    state = state.where((msg) => msg.id != messageId).toList();
  }

  void clearMessages() {
    state = [];
  }

  void updateMessage(ChatMessage updatedMessage) {
    state = [
      for (final message in state)
        if (message.id == updatedMessage.id) updatedMessage else message,
    ];
  }
}
