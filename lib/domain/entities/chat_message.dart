/// [duration] for the message to disappear in seconds
class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final int senderId;
  DateTime? readTime;
  bool isDisappearing;
  final int duration;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.senderId,
    this.isDisappearing = false,
    this.duration = 60,
    this.readTime,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    int? senderId,
    DateTime? readTime,
    bool? isDisappearing,
    int? duration,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      readTime: readTime ?? this.readTime,
      isDisappearing: isDisappearing ?? this.isDisappearing,
      duration: duration ?? this.duration,
    );
  }
}
