import 'dart:io';
import 'package:chat_challenge/core/constants/app_colors.dart';
import 'package:chat_challenge/core/constants/app_icons.dart';
import 'package:chat_challenge/core/constants/app_text_styles.dart';
import 'package:chat_challenge/presentation/widgets/upload_file_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/providers/s3_providers.dart';
import 'timer_button.dart';

class ChatInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String? imageUrl) onSend;
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

class _ChatInputWidgetState extends ConsumerState<ChatInputWidget> {
  File? _selectedImage;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        widget.controller.clear();
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
    ref.read(uploadDownloadProvider.notifier).resetState();
  }

  void _handleSend() async {
    if (_selectedImage != null) {
      // Start uploading the image
      final uploadNotifier = ref.read(uploadDownloadProvider.notifier);
      await uploadNotifier.uploadImage(_selectedImage!);

      // Check if the upload was successful
      if (uploadNotifier.state.isSuccess) {
        widget.onSend(uploadNotifier.state.fileUrl);
        setState(() {
          _selectedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: const Text('Error While Uploading'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -
                  100, // Position at the top
              left: 20,
              right: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            animation: CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeInOut,
            ),
            showCloseIcon: true,
          ),
        );
      }
    } else if (inputText.isNotEmpty) {
      // Text send logic
      widget.onSend(null);
      widget.controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadDownloadProvider);

    return Container(
      constraints: const BoxConstraints(
        minHeight: 44,
        maxHeight: 160,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          UploadFileButton(
            onTap: _pickImage,
          ),
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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                hintText: _selectedImage != null ? null : "iMessage",
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
                prefixIcon: _selectedImage != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                _selectedImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (uploadState.isUploading)
                            CircularProgressIndicator(
                              value: uploadState.progress,
                              backgroundColor: AppColors.backgroundColor,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.inputBorder),
                              strokeWidth: 4,
                            ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: _clearImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
                suffixIcon: (_selectedImage != null || inputText.isNotEmpty)
                    ? IconButton(
                        onPressed: _handleSend,
                        icon: SvgPicture.asset(AppIcons.sendButton),
                        splashRadius: 20.0,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
