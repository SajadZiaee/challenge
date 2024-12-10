import 'package:chat_challenge/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimerButton extends StatefulWidget {
  final ValueChanged<bool> onToggle;
  final bool isActivated;

  const TimerButton({
    super.key,
    required this.onToggle,
    required this.isActivated,
  });

  @override
  TimerButtonState createState() => TimerButtonState();
}

class TimerButtonState extends State<TimerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onToggle(!widget.isActivated);
      },
      icon: widget.isActivated
          ? SvgPicture.asset(
              AppIcons.timerActive,
              fit: BoxFit.cover,
            )
          : SvgPicture.asset(
              AppIcons.timerDeactive,
              fit: BoxFit.cover,
            ),
    );
  }
}
