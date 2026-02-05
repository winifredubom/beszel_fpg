// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/features/dashboard/data/service/system_records.dart';
import 'package:beszel_fpg/features/dashboard/presentation/widgets/add_system_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../widgets/server_header.dart';
import '../widgets/metric_chart_card.dart';
import '../widgets/docker_chart_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/swipe_navigation.dart';

class SystemsBoard extends ConsumerWidget {
  final String? systemId;
  const SystemsBoard({this.systemId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔍 SystemsBoard received systemId: $systemId');

    if (systemId == null || systemId!.isEmpty) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Error')),
        child: const Center(child: Text('No system ID provided')),
      );
    }

    final statsAsync = ref.watch(systemStatsProvider(systemId!));
    final containerStatsAsync = ref.watch(aggregatedContainerStatsProvider(systemId!));
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final liveSystemsAsync = ref.watch(liveSystemRecordsProvider);
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, child) {
        return SwipeNavigation(
          canSwipeBack: true,
          child: CupertinoPageScaffold(
            backgroundColor: context.backgroundColor,
            child: Stack(
              children: [
                SafeArea(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 80)),
                          SliverPadding(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingL,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                liveSystemsAsync.when(
                                  loading: () => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  error: (e, _) =>
                                      Center(child: Text('Error: $e')),
                                  data: (systemsList) {
                                    final systemList = systemsList
                                        .where((item) => item.id == systemId);
                                    final system = systemList.isNotEmpty
                                        ? systemList.first
                                        : null;
                                    if (system == null) {
                                      print('System not found $systemId');
                                      print(StackTrace.current);
                                      return const Text('System not found');
                                    }
                                    return statsAsync.when(
                                      loading: () => const Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                      error: (e, _) =>
                                          Center(child: Text('Error: $e')),
                                      data: (stats) {
                                        final cpuData = stats.items
                                            .map((e) => e.stats.cpu)
                                            .toList();
                                        final memoryData = stats.items
                                            .map((e) => e.stats.m)
                                            .toList();
                                        final diskData = stats.items
                                            .map((e) => e.stats.dp)
                                            .toList();
                                        // Disk I/O data (dr + dw = total disk I/O in MB/s)
                                        final diskIOData = stats.items
                                            .map((e) => e.stats.dr + e.stats.dw)
                                            .toList();
                                        // Bandwidth data (nr + ns = total bandwidth in MB/s)
                                        final bandwidthData = stats.items
                                            .map((e) => e.stats.nr + e.stats.ns)
                                            .toList();
                                        // Get timestamps for X-axis
                                        final timestamps = stats.items
                                            .map((e) => e.created)
                                            .toList();

                                        // Get current (latest) and max values
                                        final currentCpu = cpuData.isNotEmpty
                                            ? cpuData.last
                                            : 0.0;
                                        final maxCpu = cpuData.isNotEmpty
                                            ? cpuData.reduce(
                                                (a, b) => a > b ? a : b,
                                              )
                                            : 0.0;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ServerHeader(
                                             // isOnline: system.status == 'up',
                                              title: system.name,
                                              status: system.status,
                                              ipAddress: system.host,
                                              hostname: system.info.h,
                                              uptime: '',
                                              version: system.info.k,
                                              serverType: system.info.m,
                                              selectedPeriod: selectedPeriod,
                                              onPeriodChanged: (period) {
                                                ref.read(selectedPeriodProvider.notifier).state = period;
                                              },
                                            ),
                                            
                                            const SizedBox(
                                              height: AppDimensions.paddingL,
                                            ),
                                            Column(
                                              children: [
                                                MetricChartCard(
                                                  title: 'CPU Usage',
                                                  subtitle:
                                                      'Average system-wide CPU utilization',
                                                  currentValue:
                                                      '${currentCpu.toStringAsFixed(2)}%',
                                                  maxValue:
                                                      '${maxCpu.toStringAsFixed(2)}%',
                                                  chartColor:
                                                      AppColors.cpuColor,
                                                  data: cpuData,
                                                  timestamps: timestamps,
                                                  selectedPeriod: selectedPeriod,
                                                  unit: '%',
                                                  metricType: MetricType.cpu,
                                                  showAreaChart: true,
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Docker CPU Usage - Multi-container stacked area chart
                                                containerStatsAsync.when(
                                                  data: (containerList) => DockerChartCard(
                                                    title: 'Docker CPU Usage',
                                                    subtitle: 'Average CPU utilization of containers',
                                                    containerData: containerList,
                                                    selectedPeriod: selectedPeriod,
                                                    hasFilter: true,
                                                    unit: '%',
                                                  ),
                                                  loading: () => Container(
                                                    height: AppDimensions.chartHeight + 100,
                                                    decoration: BoxDecoration(
                                                      color: context.surfaceColor,
                                                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                                    ),
                                                    child: const Center(
                                                      child: CupertinoActivityIndicator(),
                                                    ),
                                                  ),
                                                  error: (error, stack) => Container(
                                                    height: AppDimensions.chartHeight + 100,
                                                    decoration: BoxDecoration(
                                                      color: context.surfaceColor,
                                                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Failed to load container data',
                                                        style: TextStyle(color: context.secondaryTextColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Memory Usage - single line chart
                                                MetricChartCard(
                                                  title: 'Memory Usage',
                                                  subtitle: 'Precise utilization at the recorded time',
                                                  currentValue: '${memoryData.isNotEmpty ? memoryData.last.toStringAsFixed(1) : 0} GB',
                                                  maxValue: '${memoryData.isNotEmpty ? memoryData.reduce((a, b) => a > b ? a : b).toStringAsFixed(1) : 0} GB',
                                                  chartColor: AppColors.memoryColor,
                                                  data: memoryData,
                                                  timestamps: timestamps,
                                                  selectedPeriod: selectedPeriod,
                                                  unit: ' GB',
                                                  metricType: MetricType.memory,
                                                  showAreaChart: true,
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Docker Memory Usage - Multi-container stacked area chart
                                                containerStatsAsync.when(
                                                  data: (containerList) => DockerChartCard(
                                                    title: 'Docker Memory Usage',
                                                    subtitle: 'Memory usage of docker containers',
                                                    containerData: containerList,
                                                    selectedPeriod: selectedPeriod,
                                                    hasFilter: true,
                                                    unit: 'MB',
                                                    metricType: DockerMetricType.memory,
                                                  ),
                                                  loading: () => Container(
                                                    height: AppDimensions.chartHeight + 100,
                                                    decoration: BoxDecoration(
                                                      color: context.surfaceColor,
                                                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                                    ),
                                                    child: const Center(
                                                      child: CupertinoActivityIndicator(),
                                                    ),
                                                  ),
                                                  error: (error, stack) => Container(
                                                    height: AppDimensions.chartHeight + 100,
                                                    decoration: BoxDecoration(
                                                      color: context.surfaceColor,
                                                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Failed to load container data',
                                                        style: TextStyle(color: context.secondaryTextColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Disk Usage - single line chart
                                                MetricChartCard(
                                                  title: 'Disk Usage',
                                                  subtitle: 'Usage of root partition',
                                                  currentValue: '${diskData.isNotEmpty ? diskData.last.toStringAsFixed(1) : 0} GB',
                                                  maxValue: '${diskData.isNotEmpty ? diskData.reduce((a, b) => a > b ? a : b).toStringAsFixed(1) : 0} GB',
                                                  chartColor: AppColors.diskColor,
                                                  data: diskData,
                                                  timestamps: timestamps,
                                                  selectedPeriod: selectedPeriod,
                                                  unit: ' GB',
                                                  metricType: MetricType.disk,
                                                  showAreaChart: true,
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Disk I/O - single line chart
                                                MetricChartCard(
                                                  title: 'Disk I/O',
                                                  subtitle: 'Throughput of root filesystem',
                                                  currentValue: '${diskIOData.isNotEmpty ? diskIOData.last.toStringAsFixed(3) : 0} MB/s',
                                                  maxValue: '${diskIOData.isNotEmpty ? diskIOData.reduce((a, b) => a > b ? a : b).toStringAsFixed(3) : 0} MB/s',
                                                  chartColor: AppColors.networkColor,
                                                  data: diskIOData,
                                                  timestamps: timestamps,
                                                  selectedPeriod: selectedPeriod,
                                                  unit: ' MB/s',
                                                  metricType: MetricType.diskIO,
                                                  showAreaChart: true,
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Bandwidth - single line chart
                                                MetricChartCard(
                                                  title: 'Bandwidth',
                                                  subtitle: 'Network traffic of public interfaces',
                                                  currentValue: '${bandwidthData.isNotEmpty ? bandwidthData.last.toStringAsFixed(3) : 0} MB/s',
                                                  maxValue: '${bandwidthData.isNotEmpty ? bandwidthData.reduce((a, b) => a > b ? a : b).toStringAsFixed(3) : 0} MB/s',
                                                  chartColor: AppColors.success,
                                                  data: bandwidthData,
                                                  timestamps: timestamps,
                                                  selectedPeriod: selectedPeriod,
                                                  unit: ' MB/s',
                                                  metricType: MetricType.bandwidth,
                                                  showAreaChart: true,
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // Docker Network I/O - Multi-container stacked area chart
                                                containerStatsAsync.when(
                                                  data: (containerList) => DockerChartCard(
                                                    title: 'Docker Network I/O',
                                                    subtitle: 'Network traffic of docker containers',
                                                    containerData: containerList,
                                                    selectedPeriod: selectedPeriod,
                                                    hasFilter: true,
                                                    unit: 'MB/s',
                                                    metricType: DockerMetricType.network,
                                                  ),
                                                  loading: () => Container(
                                                    height: AppDimensions.chartHeight + 100,
                                                    decoration: BoxDecoration(
                                                      color: context.surfaceColor,
                                                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                                    ),
                                                    child: const Center(
                                                      child: CupertinoActivityIndicator(),
                                                    ),
                                                  ),
                                                  error: (error, stack) => Container(
                                                    height: AppDimensions.chartHeight + 100,
                                                    decoration: BoxDecoration(
                                                      color: context.surfaceColor,
                                                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Failed to load container data',
                                                        style: TextStyle(color: context.secondaryTextColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      const CustomAppBar(isFloating: true, canGoBack: true),
                    ],
                  ),
                ),
                // Positioned(
                //   right: 16,
                //   bottom: 16,
                //   child: CupertinoButton(
                //     padding: EdgeInsets.zero,
                //     onPressed: () {
                //       showCupertinoDialog(
                //         context: context,
                //         builder: (context) => const AddSystemDialog(),
                //       );
                //     },
                //     child: Container(
                //       width: 56,
                //       height: 56,
                //       decoration: BoxDecoration(
                //         color: context.backgroundColor,
                //         borderRadius: BorderRadius.circular(28),
                //         boxShadow: [
                //           BoxShadow(
                //             color: ThemeManager.instance.isDarkMode
                //                 ? Colors.black.withOpacity(0.3)
                //                 : Colors.black.withOpacity(0.1),
                //             blurRadius: 8,
                //             offset: const Offset(0, 4),
                //           ),
                //         ],
                //       ),
                //       child: Icon(
                //         CupertinoIcons.add,
                //         color: context.textColor,
                //         size: 24,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
