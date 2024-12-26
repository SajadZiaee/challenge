/// [duration] for the message to disappear in seconds
class ChatMessage {
  final String id;
  final bool isImage;
  final String? imageUrl;
  final String text;
  final DateTime timestamp;
  final int senderId;
  final bool isDisappearing;
  final int duration;
  final DateTime? readTime;
  bool isUploading;

  ChatMessage({
    required this.id,
    required this.isImage,
    this.imageUrl,
    required this.text,
    required this.timestamp,
    required this.senderId,
    required this.isDisappearing,
    required this.duration,
    this.readTime,
    this.isUploading = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    int? senderId,
    DateTime? readTime,
    bool? isDisappearing,
    int? duration,
    bool? isImage,
    String? imageUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      readTime: readTime ?? this.readTime,
      isDisappearing: isDisappearing ?? this.isDisappearing,
      duration: duration ?? this.duration,
      isImage: isImage ?? this.isImage,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
