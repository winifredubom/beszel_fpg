// import 'package:dio/dio.dart';
// import '../config/app_config.dart';

// class NetworkClient {
//   static Dio? _dio;
  
//   static Dio get dio {
//     _dio ??= _createDio();
//     return _dio!;
//   }
  
//   static Dio _createDio() {
//     final dio = Dio(
//       BaseOptions(
//         baseUrl: AppConfig.baseUrl,
//         connectTimeout: AppConfig.connectTimeout,
//         receiveTimeout: AppConfig.requestTimeout,
//         sendTimeout: AppConfig.requestTimeout,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );
    
//     // Add interceptors
//     dio.interceptors.addAll([
//       _createLoggingInterceptor(),
//       _createAuthInterceptor(),
//       _createErrorInterceptor(),
//     ]);
    
//     return dio;
//   }
  
//   static InterceptorsWrapper _createLoggingInterceptor() {
//     return InterceptorsWrapper(
//       onRequest: (options, handler) {
//         print('🚀 REQUEST: ${options.method} ${options.path}');
//         print('📤 Headers: ${options.headers}');
//         if (options.data != null) {
//           print('📤 Data: ${options.data}');
//         }
//         handler.next(options);
//       },
//       onResponse: (response, handler) {
//         print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
//         print('📥 Data: ${response.data}');
//         handler.next(response);
//       },
//       onError: (error, handler) {
//         print('❌ ERROR: ${error.message}');
//         print('📥 Response: ${error.response?.data}');
//         handler.next(error);
//       },
//     );
//   }
  
//   static InterceptorsWrapper _createAuthInterceptor() {
//     return InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Add auth token if available
//         // This would be implemented based on Beszel's auth mechanism
//         handler.next(options);
//       },
//     );
//   }
  
//   static InterceptorsWrapper _createErrorInterceptor() {
//     return InterceptorsWrapper(
//       onError: (error, handler) {
//         final networkException = _handleDioError(error);
//         handler.reject(
//           DioException(
//             requestOptions: error.requestOptions,
//             error: networkException,
//             type: error.type,
//             response: error.response,
//           ),
//         );
//       },
//     );
//   }
  
//   static NetworkException _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return NetworkException.timeout();
//       case DioExceptionType.badResponse:
//         return NetworkException.server(
//           error.response?.statusCode ?? 0,
//           error.response?.statusMessage ?? 'Server error',
//         );
//       case DioExceptionType.cancel:
//         return NetworkException.cancelled();
//       case DioExceptionType.connectionError:
//       case DioExceptionType.unknown:
//       default:
//         return NetworkException.unknown(error.message ?? 'Unknown error');
//     }
//   }
  
//   static void updateBaseUrl(String newBaseUrl) {
//     _dio?.options.baseUrl = newBaseUrl;
//   }
  
//   static void updateAuthToken(String? token) {
//     if (token != null) {
//       _dio?.options.headers['Authorization'] = 'Bearer $token';
//     } else {
//       _dio?.options.headers.remove('Authorization');
//     }
//   }
// }

// class NetworkException implements Exception {
//   final String message;
//   final int? statusCode;
//   final NetworkExceptionType type;
  
//   const NetworkException._({
//     required this.message,
//     required this.type,
//     this.statusCode,
//   });
  
//   factory NetworkException.timeout() {
//     return const NetworkException._(
//       message: 'Connection timeout',
//       type: NetworkExceptionType.timeout,
//     );
//   }
  
//   factory NetworkException.server(int statusCode, String message) {
//     return NetworkException._(
//       message: message,
//       type: NetworkExceptionType.server,
//       statusCode: statusCode,
//     );
//   }
  
//   factory NetworkException.cancelled() {
//     return const NetworkException._(
//       message: 'Request cancelled',
//       type: NetworkExceptionType.cancelled,
//     );
//   }
  
//   factory NetworkException.unknown(String message) {
//     return NetworkException._(
//       message: message,
//       type: NetworkExceptionType.unknown,
//     );
//   }
  
//   @override
//   String toString() => message;
// }

// enum NetworkExceptionType {
//   timeout,
//   server,
//   cancelled,
//   unknown,
// }
