import 'dart:io';
import '../entities/upload_download_result.dart';

abstract class S3Repository {
  Future<String> uploadImage(File imageFile);
  Future<File> downloadImage(String imageUrl);
}
