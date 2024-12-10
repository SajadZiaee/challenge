import 'package:chat_challenge/core/constants/app_colors.dart';
import 'package:chat_challenge/core/constants/app_icons.dart';
import 'package:chat_challenge/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'timer_button.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<bool> onToggleTimer;
  final bool isTimerActivated;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onToggleTimer,
    required this.isTimerActivated,
  });

  @override
  _ChatInputWidgetState createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  late String inputText;

  @override
  void initState() {
    super.initState();
    inputText = widget.controller.text;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      inputText = widget.controller.text;
    });
  }

  void _handleSend() {
    widget.onSend();
    // Reset the controller, which will also reset the text field height
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 44,
        maxHeight: 160, // Maximum height for 4 lines
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TimerButton(
            onToggle: widget.onToggleTimer,
            isActivated: widget.isTimerActivated,
          ),
          Expanded(
            child: TextField(
              style: AppTextStyles.inputBoxTextStyle,
              controller: widget.controller,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              minLines: 1,
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (_) => _handleSend(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                hintText: "iMessage",
                filled: true,
                fillColor: AppColors.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 0.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 1,
                  ),
                ),
                hintStyle: AppTextStyles.inputBoxHintTextStyle,
                suffixIcon: inputText.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _handleSend,
                        icon: SvgPicture.asset(AppIcons.sendButton),
                        splashRadius: 20.0,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
