import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.onRetry,
  });

  String getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return '⏱️ Connection timed out. Please check your internet and try again.';
        case DioExceptionType.sendTimeout:
          return '📤 Request took too long to send. Please try again.';
        case DioExceptionType.receiveTimeout:
          return '📥 The server is taking too long to respond. Please try again later.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 404) {
            return '🔍 We couldn’t find what you’re looking for.';
          }
          if (statusCode == 401) {
            return '🔐 Session expired. Please log in again.';
          }
          if (statusCode == 500) {
            return '💥 Server error. Please try again later.';
          }
          return '❗ Unexpected error occurred (Status code: $statusCode).';
        case DioExceptionType.unknown:
          return '📡 No internet connection. Please check your network.';
        case DioExceptionType.badCertificate:
          return '🔒 SSL certificate error. Please contact support.';
        case DioExceptionType.cancel:
          return '🚫 Request was cancelled.';
        case DioExceptionType.connectionError:
          return '📶 Connection error. Please check your internet connection.';
      }
    }

    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final message = getErrorMessage(error);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('🔁 Retry'),
          )
        ],
      ),
    );
  }
}
