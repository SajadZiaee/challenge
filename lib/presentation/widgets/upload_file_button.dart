import 'package:chat_challenge/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadFileButton extends StatefulWidget {
  final Function onTap;

  const UploadFileButton({
    super.key,
    required this.onTap,
  });

  @override
  UploadFileButtonState createState() => UploadFileButtonState();
}

class UploadFileButtonState extends State<UploadFileButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.onTap();
        },
        icon: SvgPicture.asset(
          AppIcons.upload,
          fit: BoxFit.cover,
        ));
  }
}
