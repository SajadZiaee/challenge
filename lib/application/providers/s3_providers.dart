import 'package:riverpod/riverpod.dart';

import '../notifiers/s3_upload_download_notifier.dart';
import '../upload_download_state.dart';

final uploadDownloadProvider =
    StateNotifierProvider<UploadDownloadNotifier, UploadDownloadState>(
  (ref) => UploadDownloadNotifier(),
);
