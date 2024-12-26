class UploadDownloadState {
  final double progress; // Progress from 0.0 to 1.0
  final bool isUploading; // Whether the upload is in progress
  final bool isSuccess; // Whether the upload/download was successful
  final String? errorMessage; // Error message if any
  final String? fileUrl; // URL of the uploaded file

  UploadDownloadState({
    this.progress = 0.0,
    this.isUploading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.fileUrl,
  });

  UploadDownloadState copyWith({
    double? progress,
    bool? isUploading,
    bool? isSuccess,
    String? errorMessage,
    String? fileUrl,
  }) {
    return UploadDownloadState(
      progress: progress ?? this.progress,
      isUploading: isUploading ?? this.isUploading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
