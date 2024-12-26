import 'dart:io';
import '../../domain/repositories/s3_repository.dart';
import '../data_source/remote/remote_data_source.dart';

class S3RepositoryImpl implements S3Repository {
  final S3RemoteDatasource remoteDatasource;

  S3RepositoryImpl(this.remoteDatasource);

  @override
  Future<String> uploadImage(File imageFile) {
    return remoteDatasource.uploadImage(imageFile);
  }

  @override
  Future<File> downloadImage(String imageUrl) {
    throw UnimplementedError();
  }
}
