import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_challenge/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../application/providers/current_user_provider.dart';
import '../../data/data_source/remote/remote_data_source.dart';

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
  File? _downloadedImage; // Store the downloaded image file
  double _downloadProgress = 0.0; // Track download progress

  @override
  void initState() {
    super.initState();

    if (widget.message.isDisappearing) {
      _messageExpireTime = widget.message.timestamp
          .add(Duration(seconds: widget.message.duration));
      _startBlinkingTimer();
    }

    // Download the image if the message contains an image
    if (widget.message.isImage) {
      _downloadImage();
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

  Future<void> _downloadImage() async {
    try {
      final s3RemoteDatasource = S3RemoteDatasource();
      final fileName = widget.message.imageUrl!.split('/').last;

      // Simulate progress updates (replace this with actual progress updates from your upload logic)
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _downloadProgress = i / 100.0;
        });
      }

      final downloadedFile = await s3RemoteDatasource.downloadImage(fileName);
      setState(() {
        _downloadedImage = downloadedFile;
        _downloadProgress =
            1.0; // Set progress to 100% when download is complete
      });
    } catch (e) {
      print('Error downloading image: $e');
      setState(() {
        _downloadProgress = 0.0; // Reset progress on error
      });
    }
  }

  Widget _buildBlurryImage(File imageFile) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          stops: [0.5, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Image.file(
        imageFile,
        fit: BoxFit.cover,
      ),
    );
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

    if (widget.message.isImage) {
      return _downloadedImage != null
          ? BubbleNormalImage(
              id: widget.message.id,
              image: Image.file(_downloadedImage!),
              tail: widget.tail,
              isSender: isFromCurrentUser,
              color: widget.message.isDisappearing
                  ? AppColors.disappearingBubble
                  : AppColors.transparent,
            )
          : BubbleNormalImage(
              id: widget.message.id,
              image: Stack(
                alignment: Alignment.center,
                children: [
                  if (_downloadedImage != null)
                    _buildBlurryImage(_downloadedImage!),
                  CircularProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: Colors.white54,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 2,
                  ),
                ],
              ),
              tail: widget.tail,
              isSender: isFromCurrentUser,
              color: widget.message.isDisappearing
                  ? AppColors.disappearingBubble
                  : AppColors.transparent,
            );
    }

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
