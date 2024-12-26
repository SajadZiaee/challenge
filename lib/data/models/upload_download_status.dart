enum S3OperationStatus { initial, inProgress, success, failure }

class S3UploadDownloadStatus {
  final S3OperationStatus status;
  final double progress;
  final String? url;
  final String? error;

  S3UploadDownloadStatus({
    this.status = S3OperationStatus.initial,
    this.progress = 0.0,
    this.url,
    this.error,
  });

  S3UploadDownloadStatus copyWith({
    S3OperationStatus? status,
    double? progress,
    String? url,
    String? error,
  }) {
    return S3UploadDownloadStatus(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      url: url ?? this.url,
      error: error ?? this.error,
    );
  }
}
