import 'dart:io';

class UploadDownloadResult {
  final String? url;
  final File? file;
  final double progress;
  final bool isSuccess;
  final String? errorMessage;

  UploadDownloadResult({
    this.url,
    this.file,
    this.progress = 0.0,
    this.isSuccess = false,
    this.errorMessage,
  });

  UploadDownloadResult copyWith({
    String? url,
    File? file,
    double? progress,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UploadDownloadResult(
      url: url ?? this.url,
      file: file ?? this.file,
      progress: progress ?? this.progress,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
