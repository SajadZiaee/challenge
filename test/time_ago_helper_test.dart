import 'package:flutter_test/flutter_test.dart';
import 'package:chat_challenge/core/utils/time_ago_helper.dart';

void main() {
  group('timeAgoHelper', () {
    test('should return "Today HH:mm" when the date is today', () {
      final now = DateTime(2024, 12, 10, 14, 30); // Simulate today's date
      final dateTime =
          DateTime(2024, 12, 10, 10, 15); // Simulate message sent today

      final result = timeAgoHelper(dateTime);

      expect(result, 'Today 10:15');
    });

    test('should return "Yesterday HH:mm" when the date is yesterday', () {
      final now = DateTime(2024, 12, 10, 14, 30); // Simulate today's date
      final dateTime =
          DateTime(2024, 12, 9, 11, 45); // Simulate message sent yesterday

      final result = timeAgoHelper(dateTime);

      expect(result, 'Yesterday 11:45');
    });

    test('should return formatted string for a day before yesterday', () {
      final now = DateTime(2024, 12, 10, 14, 30); // Simulate today's date
      final dateTime =
          DateTime(2024, 12, 8, 9, 0); // Simulate message sent before yesterday

      final result = timeAgoHelper(dateTime);

      expect(result, 'Sun, Dec 8, 9:00');
    });
  });
}
