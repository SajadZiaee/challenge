import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_challenge/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../application/providers/current_user_provider.dart';

class MessageBubbleWidget extends ConsumerStatefulWidget {
  final ChatMessage message;
  final bool tail;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    this.tail = false,
  });

  @override
  MessageBubbleWidgetState createState() => MessageBubbleWidgetState();
}

class MessageBubbleWidgetState extends ConsumerState<MessageBubbleWidget> {
  bool _isBlinking = false;
  Timer? _timer; // Make _timer nullable
  DateTime? _messageExpireTime; // Make _messageExpireTime nullable

  @override
  void initState() {
    super.initState();

    if (widget.message.isDisappearing) {
      _messageExpireTime = widget.message.timestamp
          .add(Duration(seconds: widget.message.duration));
      _startBlinkingTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Check if _timer is initialized before canceling
    super.dispose();
  }

  void _startBlinkingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime =
          _messageExpireTime?.difference(DateTime.now()).inSeconds ?? 0;
      if (remainingTime <= 5 && remainingTime >= 0) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
      } else if (remainingTime < 0) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    bool isFromCurrentUser = widget.message.senderId == currentUser.id;

    TextStyle textStyle = widget.message.isDisappearing && _isBlinking
        ? AppTextStyles.disappearingTextStyle.copyWith(color: Colors.black)
        : widget.message.isDisappearing
            ? AppTextStyles.disappearingTextStyle
            : isFromCurrentUser
                ? AppTextStyles.senderTextStyle
                : AppTextStyles.receiverTextStyle;

    return BubbleSpecialThree(
      text: widget.message.text,
      isSender: isFromCurrentUser,
      tail: widget.tail,
      color: widget.message.isDisappearing
          ? AppColors.disappearingBubble
          : isFromCurrentUser
              ? AppColors.senderBubble
              : AppColors.receiverBubble,
      textStyle: textStyle,
    );
  }
}
