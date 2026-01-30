import 'package:beszel_fpg/core/network/pocketbase_provider.dart';
import 'package:beszel_fpg/features/dashboard/data/models/system_records_model.dart';
import 'package:beszel_fpg/features/dashboard/data/models/system_stats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final systemRecordsProvider =
    FutureProvider<SystemRecordsResponse>((ref) async {
  final pb = ref.read(pocketBaseProvider);

  debugPrint('🔐 Authenticated: ${pb.authStore.isValid}');
  debugPrint('🔑 Token: ${pb.authStore.token}');

  final resultList = await pb.collection('systems').getList(
    page: 1,
    perPage: 500,
    sort: '+name',
    fields: 'id,name,host,port,info,status',
  );

  debugPrint('✅ System records fetched: ${resultList.items.length}');
  return SystemRecordsResponse.fromJson(resultList.toJson());
});

final systemStatsProvider = FutureProvider.family<SystemStatsResponse, String>((ref, systemId) async {
  final pb = ref.read(pocketBaseProvider);


  final now = DateTime.now();
  final formatted = "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  final filter = "system='$systemId' && created > '$formatted' && type='1m'";

  // Call PocketBase collection with matching params
  final resultList = await pb.collection('system_stats').getList(
    page: 1,
    perPage: 500,
    filter: filter,
    fields: 'created,stats',
    sort: 'created',
  );

  debugPrint('✅ System stats fetched for $systemId: ${resultList.items.length}');
  return SystemStatsResponse.fromJson(resultList.toJson());
});
