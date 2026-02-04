// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_extensions.dart';

// ============================================================================
// ENUMS
// ============================================================================

/// Enum for different metric types with their own axis configurations
enum MetricType {
  cpu,           // CPU Usage
  dockerCpu,     // Docker CPU Usage
  memory,        // Memory Usage
  dockerMemory,  // Docker Memory Usage
  disk,          // Disk Usage
  diskIO,        // Disk I/O
  bandwidth,     // Bandwidth
  dockerNetwork, // Docker Network I/O
  generic,       // Generic metric
}

// ============================================================================
// CHART AXIS CONFIGURATION
// ============================================================================

/// Configuration for chart axis based on time period and metric type
/// 
/// X-axis rules (5 labels max):
/// - 1 hour: 5 min intervals (e.g., 12:00, 12:05, 12:10, 12:15, 12:20)
/// - 12 hours: 1 hour intervals
/// - 24 hours: 3 hour intervals
/// - 1 week: 1 day intervals (e.g., 27 Jan, 28 Jan, 29 Jan, 30 Jan, 31 Jan)
/// - 30 days: 2 day intervals (e.g., 5 Jan, 7 Jan, 9 Jan, 11 Jan, 13 Jan)
/// 
/// Y-axis rules for CPU (5 labels, starting from 0):
/// - 1 hour, 24 hours, 1 week: +0.25% (0%, 0.25%, 0.5%, 0.75%, 1%)
/// - 12 hours, 30 days: +0.3% (0%, 0.3%, 0.6%, 0.9%, 1.2%)
class ChartAxisConfig {
  final double yAxisInterval;
  final int xAxisLabelCount;
  final Duration xAxisInterval;
  final String Function(DateTime) xAxisFormatter;

  const ChartAxisConfig({
    required this.yAxisInterval,
    required this.xAxisLabelCount,
    required this.xAxisInterval,
    required this.xAxisFormatter,
  });

  // --------------------------------------------------------------------------
  // X-AXIS CONFIGURATION
  // --------------------------------------------------------------------------

  /// Get X-axis configuration based on selected time period
  /// Always returns 6 labels for consistent display
  static ChartAxisConfig forPeriod(String period) {
    switch (period) {
      case '1 hour':
        return ChartAxisConfig(
          yAxisInterval: 0.25,
          xAxisLabelCount: 5,
          xAxisInterval: const Duration(minutes: 5),
          xAxisFormatter: (dt) => DateFormat('HH:mm').format(dt),
        );
      
      case '12 hours':
        return ChartAxisConfig(
          yAxisInterval: 0.3,
          xAxisLabelCount: 5,
          xAxisInterval: const Duration(hours: 1),
          xAxisFormatter: (dt) => DateFormat('H:00').format(dt),
        );
      
      case '24 hours':
      case '1 day':
        return ChartAxisConfig(
          yAxisInterval: 0.25,
          xAxisLabelCount: 5,
          xAxisInterval: const Duration(hours: 3),
          xAxisFormatter: (dt) => DateFormat('HH:00').format(dt),
        );
      
      case '1 week':
        return ChartAxisConfig(
          yAxisInterval: 0.25,
          xAxisLabelCount: 5,
          xAxisInterval: const Duration(days: 1),
          xAxisFormatter: (dt) => DateFormat('d MMM').format(dt),
        );
      
      case '30 days':
      case '1 month':
        return ChartAxisConfig(
          yAxisInterval: 0.3,
          xAxisLabelCount: 5,
          xAxisInterval: const Duration(days: 2),
          xAxisFormatter: (dt) => DateFormat('d MMM').format(dt),
        );
      
      default:
        return ChartAxisConfig(
          yAxisInterval: 0.25,
          xAxisLabelCount: 5,
          xAxisInterval: const Duration(minutes: 5),
          xAxisFormatter: (dt) => DateFormat('HH:mm').format(dt),
        );
    }
  }

  // --------------------------------------------------------------------------
  // Y-AXIS CONFIGURATION
  // --------------------------------------------------------------------------

  /// Get Y-axis interval for CPU Usage based on time period
  /// - 1 hour: 0.35% (0%, 0.35%, 0.70%, 1.05%, 1.40%)
  /// - 12 hours, 24 hours, 1 week, 30 days: 0.3% (0%, 0.3%, 0.6%, 0.9%, 1.2%)
  static double getCpuYAxisInterval(String period) {
    switch (period) {
      case '1 hour':
        return 0.35;
      case '12 hours':
      case '24 hours':
      case '1 day':
      case '1 week':
      case '30 days':
      case '1 month':
        return 0.3;
      default:
        return 0.35;
    }
  }

  /// Get Y-axis interval for Docker CPU Usage based on time period
  /// - 1 hour: +0.09% (0%, 0.09%, 0.18%, 0.27%, 0.36%)
  /// - 12 hours: +0.15% (0%, 0.15%, 0.30%, 0.45%, 0.60%)
  /// - 24 hours: +0.15% (0%, 0.15%, 0.30%, 0.45%, 0.60%)
  /// - 1 week: +0.09% (0%, 0.09%, 0.18%, 0.27%, 0.36%)
  /// - 30 days: +0.1% (0%, 0.1%, 0.2%, 0.3%, 0.4%)
  static double getDockerCpuYAxisInterval(String period) {
    switch (period) {
      case '1 hour':
        return 0.09;
      case '12 hours':
        return 0.15;
      case '24 hours':
      case '1 day':
        return 0.15;
      case '1 week':
        return 0.09;
      case '30 days':
      case '1 month':
        return 0.1;
      default:
        return 0.09;
    }
  }

  /// Get Y-axis interval for Memory Usage
  /// Always 4 GB intervals regardless of time period
  /// Y-axis: 0 GB, 4 GB, 8 GB, 12 GB, 16 GB...
  static double getMemoryYAxisInterval(String period) {
    return 4.0; // Always 4 GB intervals
  }

  /// Get Y-axis interval for Disk Usage
  /// Always 120 GB intervals regardless of time period
  /// Y-axis: 0 GB, 120 GB, 240 GB, 360 GB, 480 GB...
  static double getDiskYAxisInterval(String period) {
    return 120.0; // Always 120 GB intervals
  }

  /// Get Y-axis interval for Disk I/O based on time period
  /// - 1 hour, 1 week, 30 days: 0.025 MB/s (0, 0.025, 0.05, 0.075, 0.1)
  /// - 12 hours, 24 hours: 0.05 MB/s (0, 0.05, 0.1, 0.15, 0.2)
  static double getDiskIOYAxisInterval(String period) {
    switch (period) {
      case '1 hour':
      case '1 week':
      case '30 days':
      case '1 month':
        return 0.025;
      case '12 hours':
      case '24 hours':
      case '1 day':
        return 0.05;
      default:
        return 0.025;
    }
  }

  /// Get Y-axis interval for Bandwidth based on time period
  /// All periods use 0.01 MB/s intervals
  static double getBandwidthYAxisInterval(String period) {
    return 0.01; // Always 0.01 MB/s intervals
  }

  /// Get Y-axis interval based on metric type and period
  static double getYAxisInterval(MetricType metricType, String period) {
    switch (metricType) {
      case MetricType.cpu:
        return getCpuYAxisInterval(period);
      case MetricType.dockerCpu:
        return getDockerCpuYAxisInterval(period);
      case MetricType.memory:
        return getMemoryYAxisInterval(period);
      case MetricType.disk:
        return getDiskYAxisInterval(period);
      case MetricType.diskIO:
        return getDiskIOYAxisInterval(period);
      case MetricType.bandwidth:
        return getBandwidthYAxisInterval(period);
      case MetricType.dockerMemory:
      case MetricType.dockerNetwork:
      case MetricType.generic:
        return getCpuYAxisInterval(period);
    }
  }
}

// ============================================================================
// METRIC CHART CARD WIDGET
// ============================================================================

class MetricChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentValue;
  final String maxValue;
  final Color chartColor;
  final List<double> data;
  final List<DateTime>? timestamps;
  final String selectedPeriod;
  final bool hasFilter;
  final bool showAreaChart;
  final String unit;
  final MetricType metricType;

  const MetricChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.maxValue,
    required this.chartColor,
    required this.data,
    this.timestamps,
    this.selectedPeriod = '1 hour',
    this.hasFilter = false,
    this.showAreaChart = false,
    this.unit = '%',
    this.metricType = MetricType.cpu,
  });

  @override
  Widget build(BuildContext context) {
    final axisConfig = ChartAxisConfig.forPeriod(selectedPeriod);
    
    // Get Y-axis interval based on metric type and period
    final yAxisInterval = ChartAxisConfig.getYAxisInterval(metricType, selectedPeriod);
    
    // Calculate Y-axis max based on actual data
    // Must be at least enough to show the data, using clean interval multiples
    final maxDataValue = data.isEmpty ? 0.0 : data.reduce((a, b) => a > b ? a : b);
    
    // Calculate how many intervals we need to fit the data (minimum 4 intervals = 5 labels)
    final intervalsNeeded = maxDataValue <= 0 ? 4 : (maxDataValue / yAxisInterval).ceil();
    final numIntervals = intervalsNeeded < 4 ? 4 : intervalsNeeded;
    final yAxisMax = yAxisInterval * numIntervals;
    
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: context.borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: Theme.of(context).brightness == Brightness.dark ? 20 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: AppDimensions.paddingL),
            
            // Chart
            SizedBox(
              height: AppDimensions.chartHeight,
              child: _buildChart(context, axisConfig, yAxisInterval, yAxisMax),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // UI BUILDERS
  // --------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                  fontFamily: '.SF Pro Display',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: context.secondaryTextColor,
                  fontFamily: '.SF Pro Text',
                ),
              ),
            ],
          ),
        ),
        if (hasFilter) _buildFilterButton(context),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      color: context.backgroundColor,
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.slider_horizontal_3,
            color: context.secondaryTextColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'Filter',
            style: TextStyle(
              color: context.secondaryTextColor,
              fontSize: 12,
              fontFamily: '.SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // FL_CHART IMPLEMENTATION
  // --------------------------------------------------------------------------

  Widget _buildChart(
    BuildContext context,
    ChartAxisConfig axisConfig,
    double yAxisInterval,
    double yAxisMax,
  ) {
    final spots = _createSpots();
    final timeLabels = _generateTimeLabels(axisConfig);
    
    return LineChart(
      LineChartData(
        // Grid configuration
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yAxisInterval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: chartColor.withOpacity(0.15),
              strokeWidth: 1,
            );
          },
        ),
        
        // Titles (axis labels)
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          
          // Y-axis labels (left)
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: yAxisInterval,
              getTitlesWidget: (value, meta) {
                // Only show labels at interval positions
                if (value < 0 || value > yAxisMax + 0.001) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _formatYAxisLabel(value),
                    style: TextStyle(
                      color: context.secondaryTextColor,
                      fontSize: 10,
                      fontFamily: '.SF Pro Text',
                    ),
                  ),
                );
              },
            ),
          ),
          
          // X-axis labels (bottom) - exactly 5 labels
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: data.length > 1 ? (data.length - 1) / 4 : 1,
              getTitlesWidget: (value, meta) {
                final dataLength = data.isEmpty ? 1 : data.length;
                final maxIndex = dataLength - 1;
                
                // Calculate the 5 label positions (0, 25%, 50%, 75%, 100%)
                final labelPositions = <int>{
                  0,
                  (maxIndex * 0.25).round(),
                  (maxIndex * 0.5).round(),
                  (maxIndex * 0.75).round(),
                  maxIndex,
                };
                
                final index = value.round();
                
                // Find which label index this corresponds to
                if (labelPositions.contains(index)) {
                  final labelIndex = labelPositions.toList().indexOf(index);
                  if (labelIndex >= 0 && labelIndex < timeLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        timeLabels[labelIndex],
                        style: TextStyle(
                          color: context.secondaryTextColor,
                          fontSize: 10,
                          fontFamily: '.SF Pro Text',
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        
        // Border
        borderData: FlBorderData(show: false),
        
        // Axis bounds
        minX: 0,
        maxX: (data.length - 1).toDouble().clamp(1, double.infinity),
        minY: 0,
        maxY: yAxisMax,
        
        // Touch interaction with tooltip
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => context.surfaceColor,
            tooltipBorder: BorderSide(color: context.borderColor, width: 1),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(2)}$unit',
                  TextStyle(
                    color: chartColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: '.SF Pro Text',
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: chartColor.withOpacity(0.5), strokeWidth: 1),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: chartColor,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
        
        // Line data
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.25,
            color: chartColor,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: showAreaChart
                ? BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        chartColor.withOpacity(0.35),
                        chartColor.withOpacity(0.05),
                      ],
                    ),
                  )
                : BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // --------------------------------------------------------------------------
  // DATA HELPERS
  // --------------------------------------------------------------------------

  /// Convert data list to FlSpot list for fl_chart
  List<FlSpot> _createSpots() {
    if (data.isEmpty) {
      return [const FlSpot(0, 0)];
    }
    
    return List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index]),
    );
  }

  /// Format Y-axis label value
  String _formatYAxisLabel(double value) {
    if (value == 0) return '0$unit';
    
    if (metricType == MetricType.dockerCpu && value < 1) {
      return '${value.toStringAsFixed(2)}$unit';
    }
    
    if (value == value.roundToDouble() && value == value.toInt()) {
      return '${value.toInt()}$unit';
    }
    
    if (value < 1) {
      return '${value.toStringAsFixed(2)}$unit';
    }
    
    return '${value.toStringAsFixed(1)}$unit';
  }

  /// Generate X-axis time labels based on selected period
  /// Labels are aligned to clean interval boundaries (e.g., 22:45, 22:50, 22:55 for 5-min intervals)
  List<String> _generateTimeLabels(ChartAxisConfig config) {
    const labelCount = 5;
    final now = DateTime.now();
    
    // Get the interval in minutes for rounding
    final intervalMinutes = _getIntervalMinutesForPeriod();
    
    // Round current time DOWN to the nearest interval boundary
    // e.g., if intervalMinutes=5 and current time is 22:48, round to 22:45
    final roundedNow = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      (now.minute ~/ intervalMinutes) * intervalMinutes,
    );
    
    // Calculate the total span we need to cover (labelCount - 1) intervals
    final totalIntervals = labelCount - 1;
    final spanDuration = Duration(minutes: intervalMinutes * totalIntervals);
    final startTime = roundedNow.subtract(spanDuration);
    
    // Generate labels at exact interval boundaries
    return List.generate(labelCount, (i) {
      final labelTime = startTime.add(Duration(minutes: intervalMinutes * i));
      return config.xAxisFormatter(labelTime);
    });
  }

  /// Get interval in minutes for the selected period
  int _getIntervalMinutesForPeriod() {
    switch (selectedPeriod) {
      case '1 hour':
        return 5; // 5-minute intervals for 1 hour (e.g., 22:45, 22:50, 22:55, 23:00, 23:05)
      case '12 hours':
        return 60; // 1-hour intervals for 12 hours
      case '24 hours':
      case '1 day':
        return 180; // 3-hour intervals for 24 hours
      case '1 week':
        return 60 * 24; // 1-day intervals for 1 week (in minutes)
      case '30 days':
      case '1 month':
        return 60 * 24 * 2; // 2-day intervals for 30 days
      default:
        return 5;
    }
  }

  /// Get duration for the selected period
  Duration _getDurationForPeriod() {
    switch (selectedPeriod) {
      case '1 hour':
        return const Duration(hours: 1);
      case '12 hours':
        return const Duration(hours: 12);
      case '24 hours':
      case '1 day':
        return const Duration(days: 1);
      case '1 week':
        return const Duration(days: 7);
      case '30 days':
      case '1 month':
        return const Duration(days: 30);
      default:
        return const Duration(hours: 1);
    }
  }
}
