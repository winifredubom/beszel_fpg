// import '../../../../core/storage/storage_service.dart';
// import '../models/server_model.dart';
// import 'dart:convert';

// class DashboardLocalDataSource {
//   static const String _serversKey = 'cached_servers';
//   static const String _lastUpdateKey = 'last_update';
  
//   Future<void> cacheServers(List<ServerModel> servers) async {
//     final serversJson = servers.map((server) => server.toJson()).toList();
//     await StorageService.setString(_serversKey, json.encode(serversJson));
//     await StorageService.setString(_lastUpdateKey, DateTime.now().toIso8601String());
//   }
  
//   Future<List<ServerModel>> getCachedServers() async {
//     final serversString = StorageService.getString(_serversKey);
//     if (serversString == null) {
//       return [];
//     }
    
//     final List<dynamic> serversJson = json.decode(serversString);
//     return serversJson.map((json) => ServerModel.fromJson(json)).toList();
//   }
  
//   Future<void> cacheServerStats(String serverId, SystemStatsModel stats) async {
//     await StorageService.setString('stats_$serverId', json.encode(stats.toJson()));
//   }
  
//   Future<SystemStatsModel?> getCachedServerStats(String serverId) async {
//     final statsString = StorageService.getString('stats_$serverId');
//     if (statsString == null) {
//       return null;
//     }
    
//     return SystemStatsModel.fromJson(json.decode(statsString));
//   }
  
//   Future<void> cacheDockerContainers(String serverId, List<DockerContainerModel> containers) async {
//     final containersJson = containers.map((container) => container.toJson()).toList();
//     await StorageService.setString('docker_$serverId', json.encode(containersJson));
//   }
  
//   Future<List<DockerContainerModel>> getCachedDockerContainers(String serverId) async {
//     final containersString = StorageService.getString('docker_$serverId');
//     if (containersString == null) {
//       return [];
//     }
    
//     final List<dynamic> containersJson = json.decode(containersString);
//     return containersJson.map((json) => DockerContainerModel.fromJson(json)).toList();
//   }
  
//   Future<void> clearCache() async {
//     final keys = StorageService.getKeys();
//     for (final key in keys) {
//       if (key.startsWith('cached_') || key.startsWith('stats_') || key.startsWith('docker_')) {
//         await StorageService.remove(key);
//       }
//     }
//   }
  
//   Future<DateTime?> getLastUpdateTime() async {
//     final timeString = StorageService.getString(_lastUpdateKey);
//     if (timeString == null) {
//       return null;
//     }
    
//     return DateTime.parse(timeString);
//   }
  
//   Future<bool> isCacheValid({Duration maxAge = const Duration(minutes: 5)}) async {
//     final lastUpdate = await getLastUpdateTime();
//     if (lastUpdate == null) {
//       return false;
//     }
    
//     return DateTime.now().difference(lastUpdate) < maxAge;
//   }
// }
