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
import '../widgets/time_period_selector.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/swipe_navigation.dart';

class SystemsBoard extends ConsumerWidget {
  final String? systemId;
  const SystemsBoard({ this.systemId, super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(systemStatsProvider( systemId ?? '' ));
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, child) {
        return SwipeNavigation(
          canSwipeBack: true,
          child: CupertinoPageScaffold(
          backgroundColor: context.backgroundColor,
          child: Stack(
            children :[
             SafeArea(
              child: Stack(
                children: [ CustomScrollView(
                  slivers: [
                    
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),),
                    SliverPadding(
                        padding: const EdgeInsets.all(AppDimensions.paddingL),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              // Server Header
                              const ServerHeader(
                                title: 'Civis Backend UAT Environment',
                                status: 'Up',
                                ipAddress: '167.99.242.168',
                                hostname: 'CIVIS-one-UAT',
                                uptime: '14 days',
                                  version: '5.4.0-216-generic',
                                  serverType: 'DO-Premium-AMD (4c/4t)',
                                ),
                                
                                const SizedBox(height: AppDimensions.paddingL),
                                
                                // Time Period Selector
                                TimePeriodSelector(
                                  selectedPeriod: selectedTimePeriod,
                                  onPeriodChanged: (period) {
                                    setState(() {
                                      selectedTimePeriod = period;
                                    });
                                  },
                                ),
                                
                                const SizedBox(height: AppDimensions.paddingL),
                                
                                // Metrics Grid
                                Column(
                                  children: const [
                                    // CPU Usage
                                    MetricChartCard(
                                      title: 'CPU Usage',
                                      subtitle: 'Average system-wide CPU utilization',
                                      currentValue: '8%',
                                      maxValue: '8%',
                                      chartColor: AppColors.cpuColor,
                                      data: [2, 3, 2, 2, 3, 2, 6, 3, 6, 2], // Mock data
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Docker CPU Usage
                                    MetricChartCard(
                                      title: 'Docker CPU Usage',
                                      subtitle: 'Average CPU utilization of containers',
                                      currentValue: '4%',
                                      maxValue: '4%',
                                      chartColor: AppColors.dockerColor,
                                      hasFilter: true,
                                      data: [0, 0, 0, 0, 4, 4, 0, 0], // Mock data
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Memory Usage
                                    MetricChartCard(
                                      title: 'Memory Usage',
                                      subtitle: 'Precise utilization at the recorded time',
                                      currentValue: '15.6 GB',
                                      maxValue: '15.6 GB',
                                      chartColor: AppColors.memoryColor,
                                      showAreaChart: true,
                                      data: [12, 12, 12, 12, 12, 4, 4, 4], // Mock data representing different memory sections
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Docker Memory Usage
                                    MetricChartCard(
                                      title: 'Docker Memory Usage',
                                      subtitle: 'Memory usage of docker containers',
                                      currentValue: '1.4 GB',
                                      maxValue: '1.4 GB',
                                      chartColor: AppColors.networkColor,
                                      hasFilter: true,
                                      showAreaChart: true,
                                      data: [0.2, 0.3, 0.4, 0.3, 0.2, 0.3, 0.2], // Mock data
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Disk Usage
                                    MetricChartCard(
                                      title: 'Disk Usage',
                                      subtitle: 'Usage of root partition',
                                      currentValue: '194 GB',
                                      maxValue: '194 GB',
                                      chartColor: AppColors.diskColor,
                                      showAreaChart: true,
                                      data: [194, 194, 194, 194, 194, 194, 194], // Mock data showing consistent usage
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Disk I/O
                                    MetricChartCard(
                                      title: 'Disk I/O',
                                      subtitle: 'Throughput of root filesystem',
                                      currentValue: '2 MB/s',
                                      maxValue: '2 MB/s',
                                      chartColor: AppColors.networkColor,
                                      data: [0, 0, 0, 0, 2, 0, 0], // Mock data with spike
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Bandwidth
                                    MetricChartCard(
                                      title: 'Bandwidth',
                                      subtitle: 'Network traffic of public interfaces',
                                      currentValue: '1 MB/s',
                                      maxValue: '1 MB/s',
                                      chartColor: AppColors.success,
                                      data: [0, 0, 0, 1, 1, 0, 0], // Mock data with spikes
                                    ),
                                    
                                    SizedBox(height: AppDimensions.paddingM),
                                    
                                    // Docker Network I/O
                                    MetricChartCard(
                                      title: 'Docker Network I/O',
                                      subtitle: 'Network traffic of docker containers',
                                      currentValue: '1.2 MB/s',
                                      maxValue: '1.2 MB/s',
                                      chartColor: AppColors.dockerColor,
                                      hasFilter: true,
                                      data: [0, 0, 0, 1.2, 1.1, 0, 0], // Mock data
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                     const CustomAppBar(
                  isFloating: true,
                  canGoBack: true,
                ),
                ]
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

            ]
          ),
        ),
      );
    });
  }
}