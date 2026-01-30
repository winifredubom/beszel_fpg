// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/core/network/pocketbase_provider.dart';
import 'package:beszel_fpg/core/storage/storage_service.dart';
import 'package:beszel_fpg/features/dashboard/data/service/system_records.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = FutureProvider.family<void, Map<String, String>>((
  ref,
  credentials,
) async {
  final pb = ref.read(pocketBaseProvider);

  debugPrint(
    '🔗 Login URL: ${pb.baseUrl}/api/collections/users/auth-with-password',
  );
  debugPrint('🔑 Identity: ${credentials['identity']}');

  await pb
      .collection('users')
      .authWithPassword(credentials['identity']!, credentials['password']!);

  // Persist the user email (prefer auth model value; fallback to entered identity).
  try {
    final model = pb.authStore.model;
    String? email;
    if (model != null) {
      // RecordModel exposes data map; use common field names.
      final data = model.data;
      email = (data['email'] as String?) ?? (data['username'] as String?);
    }
    await StorageService.setString(
      'user_email',
      email ?? credentials['identity']!,
    );
  } catch (_) {
    await StorageService.setString('user_email', credentials['identity']!);
  }

  // Persist PocketBase token for HTTP client (used by dio interceptor).
  final token = pb.authStore.token;
  if (token.isNotEmpty) {
    await StorageService.setString('access_token', token);
  }

  debugPrint('✅ Logged in');
  debugPrint(
    '🔗 Login URL: ${pb.baseUrl}/api/collections/users/auth-with-password',
  );
  debugPrint('🔑 Identity: ${credentials['identity']}');
  debugPrint('🔑 Token: ${pb.authStore.token}');
  debugPrint('📧 Email: ${StorageService.getString('user_email')}');
});
