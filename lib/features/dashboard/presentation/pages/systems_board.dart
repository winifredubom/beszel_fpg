// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/features/dashboard/data/models/system_records_model.dart';
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
import '../widgets/time_period_selector.dart';
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
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final systemRecordsAsync = ref.watch(systemRecordsProvider);
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
                                systemRecordsAsync.when(
                                  loading: () => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  error: (e, _) =>
                                      Center(child: Text('Error: $e')),
                                  data: (systemRecords) {
                                    final systemList = systemRecords.items
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
                                              title: system.name,
                                              status: system.status,
                                              ipAddress: system.host,
                                              hostname: system.info.h,
                                              uptime: '',
                                              version: system.info.k,
                                              serverType: system.info.m,
                                            ),
                                            const SizedBox(
                                              height: AppDimensions.paddingL,
                                            ),
                                            TimePeriodSelector(
                                              selectedPeriod: selectedPeriod,
                                              onPeriodChanged: (period) {
                                                ref.read(selectedPeriodProvider.notifier,
                                                    )
                                                        .state =
                                                    period;
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
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                MetricChartCard(
                                                  title: 'Docker CPU Usage',
                                                  subtitle: 'Average CPU utilization of containers',

                                                  currentValue: '${stats.dockerCpuUsage ?? 0}%',
                                                  maxValue: '${stats.maxDockerCpuUsage ?? 0}%',
                                                  chartColor: AppColors.dockerColor,
                                                  hasFilter: true,
                                                  data: stats.dockerCpuData ?? [0.0],
                                                ),
                                                // const SizedBox(height: AppDimensions.paddingM),
                                                // MetricChartCard(
                                                //   title: 'Memory Usage',
                                                //   subtitle: 'Precise utilization at the recorded time',
                                                //   currentValue: '${stats.memoryUsage ?? 0} GB',
                                                //   maxValue: '${stats.maxMemoryUsage ?? 0} GB',
                                                //   chartColor: AppColors.memoryColor,
                                                //   showAreaChart: true,
                                                //   data: stats.memoryData ?? [0.0],
                                                // ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // MetricChartCard(
                                                //   title: 'Docker Memory Usage',
                                                //   subtitle: 'Memory usage of docker containers',
                                                //   currentValue: '${stats.dockerMemoryUsage ?? 0} GB',
                                                //   maxValue: '${stats.maxDockerMemoryUsage ?? 0} GB',
                                                //   chartColor: AppColors.networkColor,
                                                //   hasFilter: true,
                                                //   showAreaChart: true,
                                                //   data: stats.dockerMemoryData ?? [0.0],
                                                // ),
                                                // const SizedBox(height: AppDimensions.paddingM),
                                                // MetricChartCard(
                                                //   title: 'Disk Usage',
                                                //   subtitle: 'Usage of root partition',
                                                //   currentValue: '${stats.diskUsage ?? 0} GB',
                                                //   maxValue: '${stats.maxDiskUsage ?? 0} GB',
                                                //   chartColor: AppColors.diskColor,
                                                //   showAreaChart: true,
                                                //   data: stats.diskData ?? [0.0],
                                                // ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // MetricChartCard(
                                                //   title: 'Disk I/O',
                                                //   subtitle: 'Throughput of root filesystem',
                                                //   currentValue: '${stats.diskIO ?? 0} MB/s',
                                                //   maxValue: '${stats.maxDiskIO ?? 0} MB/s',
                                                //   chartColor: AppColors.networkColor,
                                                //   data: stats.diskIOData ?? [0.0],
                                                // ),
                                                // const SizedBox(height: AppDimensions.paddingM),
                                                // MetricChartCard(
                                                //   title: 'Bandwidth',
                                                //   subtitle: 'Network traffic of public interfaces',
                                                //   currentValue: '${stats.bandwidth ?? 0} MB/s',
                                                //   maxValue: '${stats.maxBandwidth ?? 0} MB/s',
                                                //   chartColor: AppColors.success,
                                                //   data: stats.bandwidthData ?? [0.0],
                                                // ),
                                                const SizedBox(
                                                  height:
                                                      AppDimensions.paddingM,
                                                ),
                                                // MetricChartCard(
                                                //   title: 'Docker Network I/O',
                                                //   subtitle: 'Network traffic of docker containers',
                                                //   currentValue: '${stats.dockerNetworkIO ?? 0} MB/s',
                                                //   maxValue: '${stats.maxDockerNetworkIO ?? 0} MB/s',
                                                //   chartColor: AppColors.dockerColor,
                                                //   hasFilter: true,
                                                //   data: stats.dockerNetworkIOData ?? [0.0],
                                                // ),
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
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => const AddSystemDialog(),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: context.backgroundColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeManager.instance.isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.add,
                        color: context.textColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
