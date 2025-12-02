// import 'package:freezed_annotation/freezed_annotation.dart';
// import '../../domain/entities/server_entity.dart';

// part 'server_model.freezed.dart';
// part 'server_model.g.dart';

// @freezed
// class ServerModel with _$ServerModel {
//   const factory ServerModel({
//     required String id,
//     required String name,
//     required String host,
//     required int port,
//     required bool isOnline,
//     @JsonKey(name: 'last_seen') required String lastSeen,
//     String? description,
//     String? version,
//     String? os,
//     @JsonKey(name: 'system_stats') SystemStatsModel? systemStats,
//     @JsonKey(name: 'docker_containers') List<DockerContainerModel>? dockerContainers,
//   }) = _ServerModel;

//   factory ServerModel.fromJson(Map<String, dynamic> json) =>
//       _$ServerModelFromJson(json);
// }

// @freezed
// class SystemStatsModel with _$SystemStatsModel {
//   const factory SystemStatsModel({
//     @JsonKey(name: 'cpu_usage') required double cpuUsage,
//     @JsonKey(name: 'memory_usage') required double memoryUsage,
//     @JsonKey(name: 'memory_total') required double memoryTotal,
//     @JsonKey(name: 'disk_usage') required double diskUsage,
//     @JsonKey(name: 'disk_total') required double diskTotal,
//     @JsonKey(name: 'disk_read_speed') required double diskReadSpeed,
//     @JsonKey(name: 'disk_write_speed') required double diskWriteSpeed,
//     @JsonKey(name: 'network_upload') required double networkUpload,
//     @JsonKey(name: 'network_download') required double networkDownload,
//     required int uptime,
//     required String timestamp,
//   }) = _SystemStatsModel;

//   factory SystemStatsModel.fromJson(Map<String, dynamic> json) =>
//       _$SystemStatsModelFromJson(json);
// }

// @freezed
// class DockerContainerModel with _$DockerContainerModel {
//   const factory DockerContainerModel({
//     required String id,
//     required String name,
//     required String image,
//     required String status,
//     @JsonKey(name: 'cpu_usage') required double cpuUsage,
//     @JsonKey(name: 'memory_usage') required double memoryUsage,
//     @JsonKey(name: 'memory_limit') required double memoryLimit,
//     @JsonKey(name: 'network_upload') required double networkUpload,
//     @JsonKey(name: 'network_download') required double networkDownload,
//     @JsonKey(name: 'created_at') required String createdAt,
//     Map<String, String>? labels,
//   }) = _DockerContainerModel;

//   factory DockerContainerModel.fromJson(Map<String, dynamic> json) =>
//       _$DockerContainerModelFromJson(json);
// }

// @freezed
// class ChartDataModel with _$ChartDataModel {
//   const factory ChartDataModel({
//     required String timestamp,
//     required double value,
//     String? label,
//   }) = _ChartDataModel;

//   factory ChartDataModel.fromJson(Map<String, dynamic> json) =>
//       _$ChartDataModelFromJson(json);
// }

// @freezed
// class ServerConfigModel with _$ServerConfigModel {
//   const factory ServerConfigModel({
//     required String name,
//     required String host,
//     required int port,
//     String? description,
//     @JsonKey(name: 'auth_token') String? authToken,
//     @JsonKey(name: 'use_ssl') bool? useSSL,
//   }) = _ServerConfigModel;

//   factory ServerConfigModel.fromJson(Map<String, dynamic> json) =>
//       _$ServerConfigModelFromJson(json);
// }

// // Extension methods to convert between models and entities
// extension ServerModelX on ServerModel {
//   ServerEntity toEntity() {
//     return ServerEntity(
//       id: id,
//       name: name,
//       host: host,
//       port: port,
//       isOnline: isOnline,
//       lastSeen: DateTime.parse(lastSeen),
//       description: description,
//       version: version,
//       os: os,
//       systemStats: systemStats?.toEntity(),
//       dockerContainers: dockerContainers?.map((e) => e.toEntity()).toList(),
//     );
//   }
// }

// extension SystemStatsModelX on SystemStatsModel {
//   SystemStatsEntity toEntity() {
//     return SystemStatsEntity(
//       cpuUsage: cpuUsage,
//       memoryUsage: memoryUsage,
//       memoryTotal: memoryTotal,
//       diskUsage: diskUsage,
//       diskTotal: diskTotal,
//       diskReadSpeed: diskReadSpeed,
//       diskWriteSpeed: diskWriteSpeed,
//       networkUpload: networkUpload,
//       networkDownload: networkDownload,
//       uptime: Duration(seconds: uptime),
//       timestamp: DateTime.parse(timestamp),
//     );
//   }
// }

// extension DockerContainerModelX on DockerContainerModel {
//   DockerContainerEntity toEntity() {
//     return DockerContainerEntity(
//       id: id,
//       name: name,
//       image: image,
//       status: status,
//       cpuUsage: cpuUsage,
//       memoryUsage: memoryUsage,
//       memoryLimit: memoryLimit,
//       networkUpload: networkUpload,
//       networkDownload: networkDownload,
//       createdAt: DateTime.parse(createdAt),
//       labels: labels,
//     );
//   }
// }

// extension ChartDataModelX on ChartDataModel {
//   ChartDataEntity toEntity() {
//     return ChartDataEntity(
//       timestamp: DateTime.parse(timestamp),
//       value: value,
//       label: label,
//     );
//   }
// }

// extension ServerConfigEntityX on ServerConfigEntity {
//   ServerConfigModel toModel() {
//     return ServerConfigModel(
//       name: name,
//       host: host,
//       port: port,
//       description: description,
//       authToken: authToken,
//       useSSL: useSSL,
//     );
//   }
// }
