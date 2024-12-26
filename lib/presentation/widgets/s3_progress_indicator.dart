import 'package:flutter/material.dart';

class S3ProgressIndicator extends StatelessWidget {
  final double progress;
  final bool isSuccess;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const S3ProgressIndicator({
    Key? key,
    required this.progress,
    this.isSuccess = false,
    this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.red),
          Text(
            errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            )
        ],
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isSuccess ? Colors.green : Colors.blue,
          ),
        ),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
