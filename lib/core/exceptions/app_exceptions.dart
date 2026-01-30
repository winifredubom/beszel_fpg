abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });
  
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
  
  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Connection timeout. Please check your internet connection.',
      code: 'TIMEOUT',
    );
  }
  
  factory NetworkException.connectionError() {
    return const NetworkException(
      message: 'Unable to connect to server. Please check your connection.',
      code: 'CONNECTION_ERROR',
    );
  }
  
  factory NetworkException.serverError(int statusCode, String? message) {
    return NetworkException(
      message: message ?? 'Server error occurred (Code: $statusCode)',
      code: 'SERVER_ERROR_$statusCode',
    );
  }
  
  factory NetworkException.unauthorized() {
    return const NetworkException(
      message: 'Unauthorized access. Please check your credentials.',
      code: 'UNAUTHORIZED',
    );
  }
  
  factory NetworkException.forbidden() {
    return const NetworkException(
      message: 'Access forbidden. You don\'t have permission to access this resource.',
      code: 'FORBIDDEN',
    );
  }
  
  factory NetworkException.notFound() {
    return const NetworkException(
      message: 'Resource not found.',
      code: 'NOT_FOUND',
    );
  }
}

class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
  });
  
  factory StorageException.readError() {
    return const StorageException(
      message: 'Failed to read data from storage.',
      code: 'STORAGE_READ_ERROR',
    );
  }
  
  factory StorageException.writeError() {
    return const StorageException(
      message: 'Failed to write data to storage.',
      code: 'STORAGE_WRITE_ERROR',
    );
  }
  
  factory StorageException.notFound() {
    return const StorageException(
      message: 'Data not found in storage.',
      code: 'STORAGE_NOT_FOUND',
    );
  }
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
  });
  
  factory ValidationException.invalidUrl() {
    return const ValidationException(
      message: 'Invalid URL format.',
      code: 'INVALID_URL',
    );
  }
  
  factory ValidationException.invalidServerConfig() {
    return const ValidationException(
      message: 'Invalid server configuration.',
      code: 'INVALID_SERVER_CONFIG',
    );
  }
  
  factory ValidationException.missingRequiredField(String fieldName) {
    return ValidationException(
      message: '$fieldName is required.',
      code: 'MISSING_REQUIRED_FIELD',
    );
  }
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.originalError,
  });
  
  factory ServerException.unreachable() {
    return const ServerException(
      message: 'Server is unreachable. Please check the server URL and port.',
      code: 'SERVER_UNREACHABLE',
    );
  }
  
  factory ServerException.authenticationFailed() {
    return const ServerException(
      message: 'Authentication failed. Please check your credentials.',
      code: 'AUTHENTICATION_FAILED',
    );
  }
  
  factory ServerException.dataParsingError() {
    return const ServerException(
      message: 'Failed to parse server response.',
      code: 'DATA_PARSING_ERROR',
    );
  }
}
