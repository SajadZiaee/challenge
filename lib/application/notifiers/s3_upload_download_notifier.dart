import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minio/minio.dart';
import 'dart:io';

import '../../core/constants/s3_constants.dart';
import '../upload_download_state.dart';
import 'package:path/path.dart' as path;

class UploadDownloadNotifier extends StateNotifier<UploadDownloadState> {
  UploadDownloadNotifier() : super(UploadDownloadState());

  Future<void> uploadImage(File imageFile) async {
    try {
      // Reset state
      state = UploadDownloadState(isUploading: true);

      // Initialize MinIO client
      final minio = Minio(
        endPoint: S3Constants.endpoint.replaceFirst('https://', ''),
        accessKey: S3Constants.accessKey,
        secretKey: S3Constants.secretKey,
        useSSL: true,
      );

      // Generate unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

      // Open the file as a stream
      final fileStream =
          imageFile.openRead().map((chunk) => Uint8List.fromList(chunk));

      // Upload the file using putObject
      await minio.putObject(
        S3Constants.bucketName,
        fileName,
        fileStream,
        size: await imageFile.length(),
        onProgress: (progress) async {
          // Update progress
          state = state.copyWith(progress: progress / await imageFile.length());
        },
      );

      // Generate the file's public URL
      final fileUrl =
          'https://${S3Constants.endpoint}/${S3Constants.bucketName}/$fileName';

      // Update state with success and file URL
      state = state.copyWith(
        isUploading: false,
        isSuccess: true,
        fileUrl: fileUrl,
      );
    } catch (e) {
      // Update state with error
      state = state.copyWith(
        isUploading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  void resetState() {
    state = UploadDownloadState();
  }
}
