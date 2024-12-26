class S3UploadException implements Exception {
  final String message;
  S3UploadException(this.message);
}

class S3DownloadException implements Exception {
  final String message;
  S3DownloadException(this.message);
}
