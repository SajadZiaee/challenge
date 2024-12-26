import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_challenge/data/data_source/local/users_local.dart';
import '../../domain/entities/user.dart';
import '../../application/providers/message_notifier_provider.dart'; // assuming you have this provider for messages

class UserStateNotifier extends StateNotifier<User> {
  final Ref ref; // Add Ref to access other providers
  UserStateNotifier(this.ref) : super(UsersLocal.sajad);

  void setUser(User user) {
    state = user;
  }

  void toggleUser() {
    final newUser =
        state == UsersLocal.sajad ? UsersLocal.kristen : UsersLocal.sajad;
    state = newUser;

    // After the user switches, update readTime for the other user's messages
    final messages =
        ref.read(messageProvider); // Read messages from the message provider

    // Loop through messages and update readTime if the message is from the other user
    for (final message in messages) {
      if (message.senderId != newUser.id && message.readTime == null) {
        final updatedMessage = message.copyWith(readTime: DateTime.now());
        ref
            .read(messageProvider.notifier)
            .updateMessage(updatedMessage); // Update the message
      }
    }
  }
}
