import 'package:beszel_fpg/core/constants/url_variables.dart';
import 'package:beszel_fpg/core/storage/storage_service.dart';
import 'package:beszel_fpg/features/authentication/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService();
});

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushAndClearRoutes(Widget page) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/json',
  ));

  final navigationService = ref.read(navigationServiceProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = StorageService.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await StorageService.clear();
          Future.delayed(
            Duration.zero,
            () {
              navigationService.pushAndClearRoutes(const LoginPage());
            },
          );
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
