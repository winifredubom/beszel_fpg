import 'package:beszel_fpg/core/network/pocketbase_provider.dart';
import 'package:beszel_fpg/core/network/realtime_service.dart';
import 'package:beszel_fpg/features/dashboard/data/models/system_records_model.dart';
import 'package:beszel_fpg/features/dashboard/data/models/system_stats_model.dart';
import 'package:beszel_fpg/features/dashboard/data/models/container_stats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedPeriodProvider = StateProvider<String>((ref) => '1 hour');

/// Original FutureProvider for initial fetch (kept for compatibility)
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

/// Combined provider that merges initial data with realtime updates
final liveSystemRecordsProvider = StreamProvider<List<SystemRecordItem>>((ref) async* {
  final pb = ref.read(pocketBaseProvider);
  final realtimeService = ref.read(realtimeServiceProvider);

  // 1. First, fetch initial data
  debugPrint('📡 Fetching initial system records...');
  final resultList = await pb.collection('systems').getList(
    page: 1,
    perPage: 500,
    sort: '+name',
    fields: 'id,name,host,port,info,status',
  );
  
  final initialResponse = SystemRecordsResponse.fromJson(resultList.toJson());
  final systemsMap = <String, SystemRecordItem>{};
  
  for (final item in initialResponse.items) {
    systemsMap[item.id] = item;
  }
  
  debugPrint('✅ Initial systems loaded: ${systemsMap.length}');
  yield systemsMap.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  // 2. Connect to realtime if not already connected
  if (!realtimeService.isConnected) {
    try {
      await realtimeService.connect();
    } catch (e) {
      debugPrint('⚠️ Realtime connection failed, using polling fallback: $e');
    }
  }

  // 3. Listen to realtime updates
  await for (final realtimeSystems in realtimeService.systemsStream) {
    // Merge realtime updates with existing data
    for (final entry in realtimeSystems.entries) {
      final realtimeRecord = entry.value;
      
      // Convert RealtimeSystemRecord to SystemRecordItem
      systemsMap[entry.key] = SystemRecordItem(
        id: realtimeRecord.id,
        name: realtimeRecord.name,
        host: realtimeRecord.host,
        port: realtimeRecord.port,
        status: realtimeRecord.status == 'up' ? 'online' : realtimeRecord.status,
        info: SystemInfo(
          h: realtimeRecord.info.h,
          k: realtimeRecord.info.k,
          c: realtimeRecord.info.c,
          t: realtimeRecord.info.t,
          m: realtimeRecord.info.m,
          u: realtimeRecord.info.u,
          cpu: realtimeRecord.info.cpu,
          mp: realtimeRecord.info.mp,
          dp: realtimeRecord.info.dp,
          b: realtimeRecord.info.b,
          v: realtimeRecord.info.v,
          os: realtimeRecord.info.os,
        ),
      );
    }
    
    debugPrint('📡 Realtime update: ${realtimeSystems.length} systems');
    yield systemsMap.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
});

final systemStatsProvider = FutureProvider.family<SystemStatsResponse, String>((ref, systemId) async {
  final pb = ref.read(pocketBaseProvider);
  final selectedPeriod = ref.watch(selectedPeriodProvider);

  // Calculate the start time based on selected period
  final now = DateTime.now().toUtc();
  final Duration duration;
  final String type;
  
  switch (selectedPeriod) {
    case '1 hour':
      duration = const Duration(hours: 1);
      type = '1m'; // 1 minute intervals
      break;
    case '3 hours':
      duration = const Duration(hours: 3);
      type = '1m';
      break;
    case '6 hours':
      duration = const Duration(hours: 6);
      type = '1m';
      break;
    case '12 hours':
      duration = const Duration(hours: 12);
      type = '1m';
      break;
    case '24 hours':
    case '1 day':
      duration = const Duration(days: 1);
      type = '20m'; // 20 minute intervals for longer periods
      break;
    case '1 week':
      duration = const Duration(days: 7);
      type = '120m'; // 2 hour intervals
      break;
    case '1 month':
      duration = const Duration(days: 30);
      type = '480m'; // 8 hour intervals
      break;
    default:
      duration = const Duration(hours: 1);
      type = '1m';
  }
  
  final startTime = now.subtract(duration);
  final formatted = "${startTime.year.toString().padLeft(4, '0')}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')} ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:${startTime.second.toString().padLeft(2, '0')}";
  
  final filter = "system='$systemId' && created > '$formatted' && type='$type'";
  
  debugPrint('🔍 System stats filter: $filter');
  debugPrint('🌐 Full URL: ${pb.baseUrl}/api/collections/system_stats/records?filter=$filter');

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

/// Provider for container stats (Docker containers)
final containerStatsProvider = FutureProvider.family<ContainerStatsResponse, String>((ref, systemId) async {
  final pb = ref.read(pocketBaseProvider);
  final selectedPeriod = ref.watch(selectedPeriodProvider);

  // Calculate the start time based on selected period
  final now = DateTime.now().toUtc();
  final Duration duration;
  final String type;
  
  switch (selectedPeriod) {
    case '1 hour':
      duration = const Duration(hours: 1);
      type = '1m';
      break;
    case '3 hours':
      duration = const Duration(hours: 3);
      type = '1m';
      break;
    case '6 hours':
      duration = const Duration(hours: 6);
      type = '1m';
      break;
    case '12 hours':
      duration = const Duration(hours: 12);
      type = '1m';
      break;
    case '24 hours':
    case '1 day':
      duration = const Duration(days: 1);
      type = '20m';
      break;
    case '1 week':
      duration = const Duration(days: 7);
      type = '120m';
      break;
    case '1 month':
      duration = const Duration(days: 30);
      type = '480m';
      break;
    default:
      duration = const Duration(hours: 1);
      type = '1m';
  }
  
  final startTime = now.subtract(duration);
  final formatted = "${startTime.year.toString().padLeft(4, '0')}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')} ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:${startTime.second.toString().padLeft(2, '0')}";
  
  final filter = "system='$systemId' && created > '$formatted' && type='$type'";
  
  debugPrint('🐳 Container stats filter: $filter');

  final resultList = await pb.collection('container_stats').getList(
    page: 1,
    perPage: 500,
    filter: filter,
    fields: 'created,stats',
    sort: 'created',
  );

  debugPrint('✅ Container stats fetched for $systemId: ${resultList.items.length}');
  return ContainerStatsResponse.fromJson(resultList.toJson());
});

/// Provider for aggregated container data (ready for charts)
final aggregatedContainerStatsProvider = FutureProvider.family<List<AggregatedContainerData>, String>((ref, systemId) async {
  final containerStats = await ref.watch(containerStatsProvider(systemId).future);
  return aggregateContainerStats(containerStats);
});
