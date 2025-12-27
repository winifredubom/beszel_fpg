import 'package:beszel_fpg/core/storage/storage_service.dart';
import 'package:beszel_fpg/features/authentication/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AuthenticatedRequestHelper {
  static Future<Response> get(BuildContext context, String url) async {
    final accessToken =  StorageService.getString('access_token');
    if (accessToken == null) {
      throw Exception("Access token not found. User is not authenticated.");
    }
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      _handleResponse(context, response);
      return response;
    } on DioException catch (e) {
      _handleDioError(context, e);
      rethrow;
    }
  }


  static Future<Response> post(
      BuildContext context, String url, Map<String, dynamic> body) async {
    final accessToken =  StorageService.getString('access_token');
    if (accessToken == null) {
      throw Exception("Access token not found. User is not authenticated.");
    }
    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        data: body, // Send raw Map, not JSON string
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      _handleResponse(context, response);
      return response;
    } on DioException catch (e) {
      _handleDioError(context, e);
      rethrow;
    }
  }


  static Future<Response> put(
      BuildContext context, String url, Map<String, dynamic> body) async {
    final accessToken =  StorageService.getString('access_token');
    if (accessToken == null) {
      throw Exception("Access token not found. User is not authenticated.");
    }
    try {
      final dio = Dio();
      final response = await dio.put(
        url,
        data: body, // Send raw Map, not JSON string
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      _handleResponse(context, response);
      return response;
    } on DioException catch (e) {
      _handleDioError(context, e);
      rethrow;
    }
  }

  static Future<Response> patch(
      BuildContext context, String url, Map<String, dynamic> body) async {
    final accessToken =  StorageService.getString('access_token');
    if (accessToken == null) {
      throw Exception("Access token not found. User is not authenticated.");
    }
    try {
      final dio = Dio();
      final response = await dio.patch(
        url,
        data: body, // Send raw Map, not JSON string
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      _handleResponse(context, response);
      return response;
    } on DioException catch (e) {
      _handleDioError(context, e);
      rethrow;
    }
  }

  static Future<Response> delete(BuildContext context, String url) async {
    final accessToken =  StorageService.getString('access_token');
    if (accessToken == null) {
      _logoutAndRedirectToLogin(context);
      throw Exception("Access token not found. User is not authenticated.");
    }
    try {
      final dio = Dio();
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      _handleResponse(context, response);
      return response;
    } on DioException catch (e) {
      _handleDioError(context, e);
      rethrow;
    }
  }


  static void _handleResponse(BuildContext context, Response response) {
    if (response.statusCode == 401) {
      _logoutAndRedirectToLogin(context);
      throw Exception("Unauthorized: Access token is expired or invalid.");
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Request failed with status code: ${response.statusCode}");
    }
  }

  static void _handleDioError(BuildContext context, DioException e) {
    print('=== DIO ERROR DEBUG ===');
    print('Error Type: ${e.type}');
    print('Error Message: ${e.message}');
    print('Response Status Code: ${e.response?.statusCode}');
    print('Response Data: ${e.response?.data}');
    print('Request URL: ${e.requestOptions.uri}');
    print('Request Data: ${e.requestOptions.data}');
    print('Request Headers: ${e.requestOptions.headers}');
    print('=== END DIO ERROR ===');
    
    if (e.response?.statusCode == 401) {
      _logoutAndRedirectToLogin(context);
      throw Exception("Unauthorized: Access token is expired or invalid.");
    } else if (e.response?.statusCode != null) {
      // Include response data in error message for better debugging
      String errorDetails = "Status: ${e.response!.statusCode}";
      if (e.response!.data != null) {
        errorDetails += ", Response: ${e.response!.data}";
      }
      throw Exception("Request failed: $errorDetails");
    } else {
      // Enhanced network error handling
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timeout: Please check your internet connection and try again.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Request timeout: Server took too long to respond.");
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("Connection error: Unable to connect to server. Please check your internet connection.");
      } else {
        throw Exception("Network error: ${e.message ?? 'Unable to connect to server'}");
      }
    }
  }

  // static void _handleResponse(BuildContext context, http.Response response) {
  //   if (response.statusCode == 401) {
  //     SharedPreferencesHelper.getAccessToken();

  //     throw Exception("Unauthorized: Access token is expired or invalid.");
  //   } else if (response.statusCode != 200 && response.statusCode != 201) {
  //     throw Exception(
  //         "Request failed with status code: ${response.statusCode}");
  //   }
  // }

  static void _logoutAndRedirectToLogin(BuildContext context) async {
  await StorageService.remove('access_token');
  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
}
