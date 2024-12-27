import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_challenge/core/constants/app_icons.dart';
import 'package:chat_challenge/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
  File? _downloadedImage; // Store the downloaded image file
  double _downloadProgress = 0.0; // Track download progress
  bool _downloadError = false; // Track download error

  @override
  void initState() {
    super.initState();

    if (widget.message.isDisappearing) {
      _messageExpireTime = widget.message.timestamp
          .add(Duration(seconds: widget.message.duration));
      _startBlinkingTimer();
    }

    if (widget.message.isImage) {
      _downloadImage();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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
      setState(() {
        _downloadError = false;
      });

      final url = widget.message.imageUrl!;
      final request = http.Request('GET', Uri.parse(url));
      final streamedResponse = await request.send();

      final contentLength = streamedResponse.contentLength ?? 0;
      int receivedLength = 0;

      final file = File('${Directory.systemTemp.path}/${url.split('/').last}');
      final sink = file.openWrite();

      await streamedResponse.stream.listen(
        (List<int> chunk) {
          receivedLength += chunk.length;
          setState(() {
            _downloadProgress = receivedLength / contentLength;
          });
          sink.add(chunk);
        },
        onDone: () async {
          await sink.close();
          setState(() {
            _downloadedImage = file;
            _downloadProgress = 1.0;
          });
        },
        onError: (e) {
          sink.close();
          setState(() {
            _downloadProgress = 0.0;
            _downloadError = true;
          });
        },
      );
    } catch (e) {
      print('Error downloading image: $e');
      setState(() {
        _downloadProgress = 0.0;
        _downloadError = true;
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
          : _downloadError
              ? BubbleNormalImage(
                  id: widget.message.id,
                  image: GestureDetector(
                    onTap: () {
                      _downloadImage();
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.black12,
                      child: SvgPicture.asset(
                        AppIcons.reload,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
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
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.black12,
                        child: Center(
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: CircularProgressIndicator(
                              value: _downloadProgress,
                              backgroundColor: AppColors.backgroundColor,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.inputBorder),
                              strokeWidth: 4,
                            ),
                          ),
                        ),
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
