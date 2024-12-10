import 'package:intl/intl.dart';

String timeAgoHelper(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  // If the message is sent today
  if (difference.inDays == 0) {
    // Format: "Today HH:mm"
    return 'Today ${DateFormat.Hm().format(dateTime)}';
  }

  // If the message is sent yesterday
  if (difference.inDays == 1) {
    // Format: "Yesterday HH:mm"
    return 'Yesterday ${DateFormat.Hm().format(dateTime)}';
  }

  // For dates before yesterday, format as "Day, Month Day, HH:mm"
  return DateFormat('EEE, MMM d, H:mm').format(dateTime);
}
