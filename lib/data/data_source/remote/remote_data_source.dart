import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;

import '../../../core/constants/s3_constants.dart';
import '../../../core/utils/exceptions/s3_exceptions.dart';

class S3RemoteDatasource {
  Future<String> uploadImage(File imageFile) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_uploadImageIsolate, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send([
      imageFile.path,
      responsePort.sendPort,
      S3Constants.accessKey,
      S3Constants.secretKey,
      S3Constants.endpoint,
      S3Constants.bucketName
    ]);

    final result = await responsePort.first;
    if (result is String) {
      return result;
    } else {
      throw S3UploadException('Upload failed');
    }
  }

  Future<File> downloadImage(String fileName) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_downloadImageIsolate, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send([
      fileName,
      responsePort.sendPort,
      S3Constants.accessKey,
      S3Constants.secretKey,
      S3Constants.endpoint,
      S3Constants.bucketName
    ]);

    final result = await responsePort.first;
    if (result is File) {
      return result;
    } else {
      throw S3DownloadException('Download failed');
    }
  }

  static void _uploadImageIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      final filePath = message[0] as String;
      final responseSendPort = message[1] as SendPort;
      final accessKey = message[2] as String;
      final secretKey = message[3] as String;
      final endpoint = message[4] as String;
      final bucketName = message[5] as String;

      try {
        // Initialize MinIO client
        final minio = Minio(
          endPoint: endpoint.replaceFirst('https://', ''), // Remove 'https://'
          accessKey: accessKey,
          secretKey: secretKey,
          useSSL: true, // Use HTTPS for ArvanCloud
        );

        // Generate unique filename
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(filePath)}';

        // Open the file as a stream
        final file = File(filePath);
        final fileStream =
            file.openRead().map((chunk) => Uint8List.fromList(chunk));

        // Upload the file using putObject
        await minio.putObject(
          bucketName,
          fileName,
          fileStream,
          size: await file.length(), // Total file size
          onProgress: (progress) {
            print('Upload progress: $progress bytes');
          },
          metadata: {
            'x-amz-acl': 'public-read', // Set object to be publicly readable
          },
        );

        // Generate the file's public URL
        final fileUrl = 'https://$endpoint/$bucketName/$fileName';
        print('File uploaded successfully: $fileUrl');
        responseSendPort.send(fileUrl);
      } catch (e) {
        print('Upload error: $e');
        responseSendPort.send(null);
      }
    });
  }

  static void _downloadImageIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      final fileName = message[0] as String;
      final responseSendPort = message[1] as SendPort;
      final accessKey = message[2] as String;
      final secretKey = message[3] as String;
      final endpoint = message[4] as String;
      final bucketName = message[5] as String;

      try {
        // Initialize MinIO client
        final minio = Minio(
          endPoint: endpoint.replaceFirst('https://', ''), // Remove 'https://'
          accessKey: accessKey,
          secretKey: secretKey,
          useSSL: true, // Use HTTPS for ArvanCloud
        );

        // Create a temporary file to save the downloaded image
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/$fileName');

        // Download the file using getObject
        final stream = await minio.getObject(bucketName, fileName);

        // Flatten the stream into a single list of bytes
        final List<int> bytes = await stream.expand((chunk) => chunk).toList();

        // Write the bytes to the file
        await tempFile.writeAsBytes(bytes);

        print('File downloaded successfully: ${tempFile.path}');
        responseSendPort.send(tempFile);
      } catch (e) {
        print('Download error: $e');
        responseSendPort.send(null);
      }
    });
  }
}
