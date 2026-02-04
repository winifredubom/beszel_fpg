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

  // Persist the user email and role (prefer auth model value; fallback to entered identity).
  try {
    final model = pb.authStore.model;
    String? email;
    String? role;
    if (model != null) {
      // RecordModel exposes data map; use common field names.
      final data = model.data;
      debugPrint('🔍 Model data: $data');
      email = (data['email'] as String?) ?? (data['username'] as String?);
      role = data['role'] as String?;
      debugPrint('🔍 Extracted role: $role');
    }
    await StorageService.setString(
      'user_email',
      email ?? credentials['identity']!,
    );
    // Store user role for role-based UI
    await StorageService.setString('user_role', role ?? 'user');
  } catch (e) {
    debugPrint('❌ Error extracting user data: $e');
    await StorageService.setString('user_email', credentials['identity']!);
    await StorageService.setString('user_role', 'user');
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
  debugPrint('Role: ${StorageService.getString('user_role')}');
  debugPrint('🔑 Identity: ${credentials['identity']}');
  debugPrint('🔑 Token: ${pb.authStore.token}');
  debugPrint('📧 Email: ${StorageService.getString('user_email')}');
  debugPrint('👤 Role: ${StorageService.getString('user_role')}');
});
