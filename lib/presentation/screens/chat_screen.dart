import 'dart:async';
import 'package:chat_challenge/core/constants/app_colors.dart';
import 'package:chat_challenge/presentation/widgets/custom_appbar.dart';
import 'package:chat_challenge/presentation/widgets/message_bubble_widget.dart';
import 'package:chat_challenge/presentation/widgets/timestamp_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/message_notifier_provider.dart';
import '../../core/utils/time_ago_helper.dart';
import '../../domain/entities/chat_message.dart';
import '../widgets/chat_input_widget.dart';
import '../../application/providers/current_user_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  bool _isDisappearingEnabled = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    print('object');
    FocusScope.of(context).unfocus();
  }

  void _handleSend(String messageText, int senderId, {String? imageUrl}) {
    final newMessage = ChatMessage(
      id: DateTime.now().toString(),
      isImage: imageUrl != null,
      imageUrl: imageUrl,
      text: messageText,
      timestamp: DateTime.now(),
      senderId: senderId,
      isDisappearing: _isDisappearingEnabled,
      duration: 60,
    );

    ref.read(messageProvider.notifier).addMessage(newMessage);

    if (_isDisappearingEnabled) {
      Future.delayed(Duration(seconds: newMessage.duration), () {
        ref.read(messageProvider.notifier).deleteMessage(newMessage.id);
      });
    }

  }

  void _toggleDisappearingMessages(bool isActivated) {
    setState(() {
      _isDisappearingEnabled = isActivated;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final messages = ref.watch(messageProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final timeAgo = timeAgoHelper(message.timestamp);

                  bool hasTail = false;
                  if (index == messages.length - 1) {
                    hasTail = true;
                  } else {
                    final nextMessage = messages[index + 1];
                    if (nextMessage.senderId != message.senderId) {
                      hasTail = true;
                    } else {
                      final timeDifference = nextMessage.timestamp
                          .difference(message.timestamp)
                          .inMinutes;
                      if (timeDifference > 2) {
                        hasTail = true;
                      }
                    }
                  }

                  bool showTimestamp = false;
                  if (index == 0) {
                    showTimestamp = true;
                  } else {
                    final previousMessage = messages[index - 1];
                    final timeDifference =
                        message.timestamp.difference(previousMessage.timestamp);
                    if (timeDifference.inMinutes > 5) {
                      showTimestamp = true;
                    }
                  }

                  String? readTimeDisplay;
                  if (message.senderId == currentUser.id &&
                      message.readTime != null) {
                    readTimeDisplay = timeAgoHelper(message.readTime!);
                  }

                  return Dismissible(
                    key: ValueKey(message.id),
                    direction: message.senderId != currentUser.id
                        ? DismissDirection.endToStart
                        : DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      ref
                          .read(messageProvider.notifier)
                          .deleteMessage(message.id);
                    },
                    background: message.senderId != currentUser.id
                        ? Container()
                        : Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                    secondaryBackground: message.senderId != currentUser.id
                        ? Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : Container(),
                    child: Column(
                      crossAxisAlignment: message.senderId != currentUser.id
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (showTimestamp) TimestampWidget(timeAgo: timeAgo),
                        if (showTimestamp) const SizedBox(height: 8),
                        MessageBubbleWidget(
                          message: message,
                          tail: hasTail,
                        ),
                        if (readTimeDisplay != null && hasTail)
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0, top: 4),
                            child: Text(
                              'Read $readTimeDisplay',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ChatInputWidget(
              controller: _controller,
              onSend: (String? imageUrl) {
                _handleSend(_controller.text, currentUser.id,
                    imageUrl: imageUrl);
                _controller.clear();
              },
              onToggleTimer: (bool value) {
                _toggleDisappearingMessages(value);
              },
              isTimerActivated: _isDisappearingEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
