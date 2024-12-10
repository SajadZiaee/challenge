import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_message.dart';
import '../notifiers/message_notifier.dart';

final messageProvider =
    StateNotifierProvider<MessageNotifier, List<ChatMessage>>(
  (ref) => MessageNotifier(),
);
