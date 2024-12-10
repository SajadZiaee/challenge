import 'package:chat_challenge/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppTextStyles {
  static const TextStyle timeStampTextStyle = TextStyle(
      //   fontFamily: 'SFPro',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.date);

  static const TextStyle avatarTextStyle = TextStyle(
      //   fontFamily: 'SFPro',
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.titleColor);

  static const TextStyle receiverTextStyle = TextStyle(
      //   fontFamily: 'SFPro',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: AppColors.receiverText);

  static const TextStyle senderTextStyle = TextStyle(
    //   fontFamily: 'SFPro',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.senderText,
  );

  static const TextStyle disappearingTextStyle = TextStyle(
    //   fontFamily: 'SFPro',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.senderText,
  );

  static const TextStyle inputBoxHintTextStyle = TextStyle(
      //   fontFamily: 'SFPro',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: AppColors.inputHint);

  static const TextStyle inputBoxTextStyle = TextStyle(
      //   fontFamily: 'SFPro',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: AppColors.inputText);
}
