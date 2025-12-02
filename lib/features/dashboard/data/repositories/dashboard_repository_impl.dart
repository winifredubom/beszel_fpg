// import 'package:fpdart/fpdart.dart';
// import '../../domain/entities/server_entity.dart';
// import '../../domain/repositories/dashboard_repository.dart';
// import '../datasources/dashboard_api.dart';
// import '../datasources/dashboard_local_data_source.dart';
// import '../models/server_model.dart';
// import '../../../../core/exceptions/app_exceptions.dart';

// class DashboardRepositoryImpl implements DashboardRepository {
//   final DashboardApi _api;
//   final DashboardLocalDataSource _localDataSource;

//   DashboardRepositoryImpl(this._api, this._localDataSource);

//   @override
//   Future<Either<AppException, List<ServerEntity>>> getServers() async {
//     try {
//       // Try to get cached data first
//       if (await _localDataSource.isCacheValid()) {
//         final cachedServers = await _localDataSource.getCachedServers();
//         if (cachedServers.isNotEmpty) {
//           return Right(cachedServers.map((model) => model.toEntity()).toList());
//         }
//       }

//       // Fetch from API
//       final servers = await _api.getServers();
      
//       // Cache the results
//       await _localDataSource.cacheServers(servers);
      
//       return Right(servers.map((model) => model.toEntity()).toList());
//     } catch (e) {
//       if (e is NetworkException) {
//         // Try to return cached data even if expired
//         try {
//           final cachedServers = await _localDataSource.getCachedServers();
//           if (cachedServers.isNotEmpty) {
//             return Right(cachedServers.map((model) => model.toEntity()).toList());
//           }
//         } catch (_) {}
        
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, ServerEntity>> getServerById(String id) async {
//     try {
//       final server = await _api.getServerById(id);
//       return Right(server.toEntity());
//     } catch (e) {
//       if (e is NetworkException) {
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, SystemStatsEntity>> getServerStats(String serverId) async {
//     try {
//       final stats = await _api.getServerStats(serverId);
      
//       // Cache the stats
//       await _localDataSource.cacheServerStats(serverId, stats);
      
//       return Right(stats.toEntity());
//     } catch (e) {
//       if (e is NetworkException) {
//         // Try to return cached stats
//         try {
//           final cachedStats = await _localDataSource.getCachedServerStats(serverId);
//           if (cachedStats != null) {
//             return Right(cachedStats.toEntity());
//           }
//         } catch (_) {}
        
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, List<DockerContainerEntity>>> getDockerContainers(String serverId) async {
//     try {
//       final containers = await _api.getDockerContainers(serverId);
      
//       // Cache the containers
//       await _localDataSource.cacheDockerContainers(serverId, containers);
      
//       return Right(containers.map((model) => model.toEntity()).toList());
//     } catch (e) {
//       if (e is NetworkException) {
//         // Try to return cached containers
//         try {
//           final cachedContainers = await _localDataSource.getCachedDockerContainers(serverId);
//           if (cachedContainers.isNotEmpty) {
//             return Right(cachedContainers.map((model) => model.toEntity()).toList());
//           }
//         } catch (_) {}
        
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, List<ChartDataEntity>>> getChartData(
//     String serverId,
//     String metricType,
//     DateTime startTime,
//     DateTime endTime,
//   ) async {
//     try {
//       final chartData = await _api.getChartData(
//         serverId,
//         metricType,
//         startTime.toIso8601String(),
//         endTime.toIso8601String(),
//       );
      
//       return Right(chartData.map((model) => model.toEntity()).toList());
//     } catch (e) {
//       if (e is NetworkException) {
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, ServerEntity>> addServer(ServerConfigEntity config) async {
//     try {
//       final serverModel = config.toModel();
//       final server = await _api.addServer(serverModel);
      
//       // Clear cache to force refresh
//       await _localDataSource.clearCache();
      
//       return Right(server.toEntity());
//     } catch (e) {
//       if (e is NetworkException) {
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, ServerEntity>> updateServer(String id, ServerConfigEntity config) async {
//     try {
//       final serverModel = config.toModel();
//       final server = await _api.updateServer(id, serverModel);
      
//       // Clear cache to force refresh
//       await _localDataSource.clearCache();
      
//       return Right(server.toEntity());
//     } catch (e) {
//       if (e is NetworkException) {
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, void>> removeServer(String id) async {
//     try {
//       await _api.removeServer(id);
      
//       // Clear cache to force refresh
//       await _localDataSource.clearCache();
      
//       return const Right(null);
//     } catch (e) {
//       if (e is NetworkException) {
//         return Left(e);
//       }
//       return Left(ServerException.dataParsingError());
//     }
//   }

//   @override
//   Future<Either<AppException, bool>> testConnection(ServerConfigEntity config) async {
//     try {
//       final serverModel = config.toModel();
//       final result = await _api.testConnection(serverModel);
      
//       return Right(result['success'] ?? false);
//     } catch (e) {
//       if (e is NetworkException) {
//         return Left(e);
//       }
//       return Left(ServerException.unreachable());
//     }
//   }
// }
