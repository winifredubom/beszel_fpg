// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import '../models/server_model.dart';

// part 'dashboard_api.g.dart';

// @RestApi()
// abstract class DashboardApi {
//   factory DashboardApi(Dio dio, {String baseUrl}) = _DashboardApi;

//   @GET('/api/systems')
//   Future<List<ServerModel>> getServers();

//   @GET('/api/systems/{id}')
//   Future<ServerModel> getServerById(@Path() String id);

//   @GET('/api/systems/{id}/stats')
//   Future<SystemStatsModel> getServerStats(@Path() String id);

//   @GET('/api/systems/{id}/docker')
//   Future<List<DockerContainerModel>> getDockerContainers(@Path() String id);

//   @GET('/api/systems/{id}/stats/history')
//   Future<List<ChartDataModel>> getChartData(
//     @Path() String id,
//     @Query('metric') String metricType,
//     @Query('start') String startTime,
//     @Query('end') String endTime,
//   );

//   @POST('/api/systems')
//   Future<ServerModel> addServer(@Body() ServerConfigModel config);

//   @PUT('/api/systems/{id}')
//   Future<ServerModel> updateServer(
//     @Path() String id,
//     @Body() ServerConfigModel config,
//   );

//   @DELETE('/api/systems/{id}')
//   Future<void> removeServer(@Path() String id);

//   @POST('/api/systems/test')
//   Future<Map<String, dynamic>> testConnection(@Body() ServerConfigModel config);
// }
