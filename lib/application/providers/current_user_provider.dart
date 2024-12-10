import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../notifiers/user_state_notifier.dart';

final currentUserProvider =
    StateNotifierProvider<UserStateNotifier, User>((ref) {
  return UserStateNotifier(ref); // Passing the ref to the UserStateNotifier
});
