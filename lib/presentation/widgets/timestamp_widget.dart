import 'package:flutter/widgets.dart';

import '../../core/constants/app_text_styles.dart';

class TimestampWidget extends StatelessWidget {
  final String timeAgo;
  const TimestampWidget({super.key, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        timeAgo,
        style: AppTextStyles.timeStampTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
