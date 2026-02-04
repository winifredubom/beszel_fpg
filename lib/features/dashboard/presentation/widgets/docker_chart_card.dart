// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../data/models/container_stats_model.dart';

// ============================================================================
// DOCKER CHART CARD WIDGET
// ============================================================================

/// Type of Docker metric to display
enum DockerMetricType {
  cpu,     // Docker CPU Usage (%)
  memory,  // Docker Memory Usage (MB/GB)
  network, // Docker Network I/O (MB/s)
}

/// A chart card specifically for Docker container metrics
/// Displays multiple containers as stacked/overlapping area charts with different colors
class DockerChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AggregatedContainerData> containerData;
  final String selectedPeriod;
  final bool hasFilter;
  final String unit;
  final VoidCallback? onFilterTap;
  final DockerMetricType metricType;

  const DockerChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.containerData,
    this.selectedPeriod = '1 hour',
    this.hasFilter = false,
    this.unit = '%',
    this.onFilterTap,
    this.metricType = DockerMetricType.cpu,
  });

  // Predefined colors for containers (matches the reference image)
  static const List<Color> containerColors = [
    Color(0xFFE53935), // Red
    Color(0xFFFF9800), // Orange
    Color(0xFFCDDC39), // Lime
    Color(0xFF8BC34A), // Light Green
    Color(0xFF4CAF50), // Green
    Color(0xFF009688), // Teal
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF3F51B5), // Indigo
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate max stacked value first to determine appropriate Y-axis scaling
    final maxStackedValue = _calculateMaxStackedValue();
    
    // Get Y-axis interval dynamically based on actual data range
    // This ensures the chart "zooms in" on the data for better visibility
    final yAxisInterval = _getDynamicYAxisInterval(maxStackedValue);
    
    // Calculate how many intervals we need to fit the data (minimum 4 intervals = 5 labels)
    final intervalsNeeded = maxStackedValue <= 0 ? 4 : (maxStackedValue / yAxisInterval).ceil();
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
              child: _buildChart(context, yAxisInterval, yAxisMax),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Y-AXIS CONFIGURATION FOR DOCKER METRICS
  // --------------------------------------------------------------------------

  /// Get dynamic Y-axis interval based on actual data range
  /// This ensures the chart scales appropriately to spread out the data vertically
  double _getDynamicYAxisInterval(double maxValue) {
    if (maxValue <= 0) {
      // Return default minimum intervals when no data
      return _getDefaultMinInterval();
    }
    
    // Target 4-5 intervals for good readability
    const targetIntervals = 4;
    final rawInterval = maxValue / targetIntervals;
    
    // Round to a "nice" interval value based on metric type
    return _roundToNiceInterval(rawInterval);
  }

  /// Get default minimum interval when there's no data
  double _getDefaultMinInterval() {
    switch (metricType) {
      case DockerMetricType.memory:
        return 50.0; // 50 MB minimum interval
      case DockerMetricType.network:
        return 0.005; // 0.005 MB/s minimum interval
      case DockerMetricType.cpu:
        return 0.05; // 0.05% minimum interval
    }
  }

  /// Round interval to a "nice" human-readable value
  double _roundToNiceInterval(double rawInterval) {
    switch (metricType) {
      case DockerMetricType.memory:
        // Nice memory intervals: 10, 25, 50, 100, 250, 500, 1000 MB
        if (rawInterval <= 10) return 10;
        if (rawInterval <= 25) return 25;
        if (rawInterval <= 50) return 50;
        if (rawInterval <= 100) return 100;
        if (rawInterval <= 250) return 250;
        if (rawInterval <= 500) return 500;
        if (rawInterval <= 1000) return 1000;
        // For very large values, round to nearest 500 MB
        return ((rawInterval / 500).ceil() * 500).toDouble();
        
      case DockerMetricType.network:
        // Nice network intervals: 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5 MB/s
        if (rawInterval <= 0.005) return 0.005;
        if (rawInterval <= 0.01) return 0.01;
        if (rawInterval <= 0.025) return 0.025;
        if (rawInterval <= 0.05) return 0.05;
        if (rawInterval <= 0.1) return 0.1;
        if (rawInterval <= 0.25) return 0.25;
        if (rawInterval <= 0.5) return 0.5;
        return ((rawInterval / 0.5).ceil() * 0.5);
        
      case DockerMetricType.cpu:
        // Nice CPU intervals: 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10%
        if (rawInterval <= 0.05) return 0.05;
        if (rawInterval <= 0.1) return 0.1;
        if (rawInterval <= 0.25) return 0.25;
        if (rawInterval <= 0.5) return 0.5;
        if (rawInterval <= 1) return 1;
        if (rawInterval <= 2.5) return 2.5;
        if (rawInterval <= 5) return 5;
        if (rawInterval <= 10) return 10;
        return ((rawInterval / 10).ceil() * 10).toDouble();
    }
  }

  /// Get Y-axis interval based on metric type (legacy - kept for reference)
  /// 
  /// Docker CPU Usage (by time period):
  /// - 1 hour: +0.09%
  /// - 12 hours: +0.15%
  /// - 24 hours: +0.15%
  /// - 1 week: +0.09%
  /// - 30 days: +0.1%
  /// 
  /// Docker Memory Usage (same for all periods):
  /// - Always +450 MB (0 MB, 450 MB, 900 MB, 1.35 GB, 1.8 GB...)
  /// 
  /// Docker Network I/O (same for all periods):
  /// - Always +0.01 MB/s
  double _getYAxisInterval() {
    switch (metricType) {
      case DockerMetricType.memory:
        return 450.0; // 450 MB intervals for memory
      case DockerMetricType.network:
        return 0.01; // 0.01 MB/s intervals for network
      case DockerMetricType.cpu:
        // Docker CPU intervals by period
        switch (selectedPeriod) {
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
  }

  /// Calculate max stacked value (sum of all containers at each point)
  double _calculateMaxStackedValue() {
    if (containerData.isEmpty) return 0.0;
    
    // Get the appropriate data based on metric type
    List<double> Function(AggregatedContainerData) getData;
    switch (metricType) {
      case DockerMetricType.memory:
        getData = (c) => c.memoryData;
        break;
      case DockerMetricType.network:
        getData = (c) => c.networkData;
        break;
      case DockerMetricType.cpu:
        getData = (c) => c.cpuData;
        break;

    }
    
    // Find the max data length
    int maxLength = 0;
    for (final container in containerData) {
      final data = getData(container);
      if (data.length > maxLength) {
        maxLength = data.length;
      }
    }
    
    // Calculate stacked sum at each time point
    double maxSum = 0.0;
    for (int i = 0; i < maxLength; i++) {
      double sum = 0.0;
      for (final container in containerData) {
        final data = getData(container);
        if (i < data.length) {
          sum += data[i];
        }
      }
      if (sum > maxSum) maxSum = sum;
    }
    
    return maxSum;
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
      onPressed: onFilterTap,
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
  // FL_CHART IMPLEMENTATION - STACKED AREA CHART
  // --------------------------------------------------------------------------

  Widget _buildChart(
    BuildContext context,
    double yAxisInterval,
    double yAxisMax,
  ) {
    if (containerData.isEmpty) {
      return Center(
        child: Text(
          'No container data available',
          style: TextStyle(
            color: context.secondaryTextColor,
            fontSize: 14,
          ),
        ),
      );
    }

    final timeLabels = _generateTimeLabels();
    final lineBarsData = _createLineBarsData();
    final maxDataLength = _getMaxDataLength();
    
    return LineChart(
      LineChartData(
        // Grid configuration
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yAxisInterval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.15),
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
          
          // X-axis labels (bottom) - 5 labels
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: maxDataLength > 1 ? (maxDataLength - 1) / 4 : 1,
              getTitlesWidget: (value, meta) {
                final maxIndex = maxDataLength - 1;
                
                final labelPositions = <int>{
                  0,
                  (maxIndex * 0.25).round(),
                  (maxIndex * 0.5).round(),
                  (maxIndex * 0.75).round(),
                  maxIndex,
                };
                
                final index = value.round();
                
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
        maxX: (maxDataLength - 1).toDouble().clamp(1, double.infinity),
        minY: 0,
        maxY: yAxisMax,
        
        // Touch interaction with tooltip showing all containers
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => context.surfaceColor,
            tooltipBorder: BorderSide(color: context.borderColor, width: 1),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(12),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              // Sort by value descending for consistent display
              final sortedSpots = touchedSpots.toList()
                ..sort((a, b) => b.y.compareTo(a.y));
              
              return sortedSpots.map((spot) {
                final containerIndex = spot.barIndex;
                final containerName = containerIndex < containerData.length 
                    ? containerData[containerIndex].containerName 
                    : 'Unknown';
                final color = containerColors[containerIndex % containerColors.length];
                
                // Truncate long container names
                final displayName = containerName.length > 20 
                    ? '${containerName.substring(0, 17)}...' 
                    : containerName;
                
                // Format value based on metric type
                String formattedValue;
                if (metricType == DockerMetricType.memory) {
                  if (spot.y >= 1000) {
                    formattedValue = '${(spot.y / 1000).toStringAsFixed(2)} GB';
                  } else {
                    formattedValue = '${spot.y.toStringAsFixed(0)} MB';
                  }
                } else {
                  formattedValue = '${spot.y.toStringAsFixed(2)}$unit';
                }
                
                return LineTooltipItem(
                  '$displayName: $formattedValue',
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
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
                FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: barData.color ?? Colors.blue,
                      strokeWidth: 1,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
        
        // Line data - multiple lines for each container
        lineBarsData: lineBarsData,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // --------------------------------------------------------------------------
  // DATA HELPERS
  // --------------------------------------------------------------------------

  int _getMaxDataLength() {
    int maxLength = 1;
    
    // Get the appropriate data based on metric type
    List<double> Function(AggregatedContainerData) getData;
    switch (metricType) {
      case DockerMetricType.memory:
        getData = (c) => c.memoryData;
        break;
      case DockerMetricType.network:
        getData = (c) => c.networkData;
        break;
      case DockerMetricType.cpu:
        getData = (c) => c.cpuData;
        break;
    }
    
    for (final container in containerData) {
      final data = getData(container);
      if (data.length > maxLength) {
        maxLength = data.length;
      }
    }
    return maxLength;
  }

  /// Create line bar data for each container
  List<LineChartBarData> _createLineBarsData() {
    final List<LineChartBarData> lines = [];
    final maxLength = _getMaxDataLength();
    
    // Get the appropriate data based on metric type
    List<double> Function(AggregatedContainerData) getData;
    switch (metricType) {
      case DockerMetricType.memory:
        getData = (c) => c.memoryData;
        break;
      case DockerMetricType.network:
        getData = (c) => c.networkData;
        break;
      case DockerMetricType.cpu:
        getData = (c) => c.cpuData;
        break;
    }
    
    for (int i = 0; i < containerData.length; i++) {
      final container = containerData[i];
      final color = containerColors[i % containerColors.length];
      final data = getData(container);
      
      // Create spots, padding with last value if needed
      final spots = <FlSpot>[];
      for (int j = 0; j < maxLength; j++) {
        final value = j < data.length 
            ? data[j] 
            : (data.isNotEmpty ? data.last : 0.0);
        spots.add(FlSpot(j.toDouble(), value));
      }
      
      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.2,
          color: color,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: color.withOpacity(0.3),
          ),
        ),
      );
    }
    
    return lines;
  }

  /// Format Y-axis label value
  String _formatYAxisLabel(double value) {
    if (value == 0) return '0 $unit';
    
    // For memory metrics, format as MB or GB
    if (metricType == DockerMetricType.memory) {
      if (value >= 1000) {
        // Convert to GB
        final gbValue = value / 1000;
        if (gbValue == gbValue.roundToDouble()) {
          return '${gbValue.toInt()} GB';
        }
        return '${gbValue.toStringAsFixed(2)} GB';
      } else {
        // Keep as MB
        if (value == value.roundToDouble()) {
          return '${value.toInt()} MB';
        }
        return '${value.toStringAsFixed(0)} MB';
      }
    }
    
    // For CPU metrics
    if (value < 1) {
      // Show 2 decimal places for small values
      final formatted = value.toStringAsFixed(2);
      // Remove trailing zeros
      final trimmed = formatted.replaceAll(RegExp(r'\.?0+$'), '');
      return '$trimmed$unit';
    }
    
    return '${value.toStringAsFixed(1)}$unit';
  }

  /// Generate X-axis time labels based on selected period
  /// Labels are aligned to clean interval boundaries (e.g., 22:45, 22:50, 22:55 for 5-min intervals)
  List<String> _generateTimeLabels() {
    const labelCount = 5;
    final now = DateTime.now();
    final formatter = _getXAxisFormatter();
    
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
      return formatter(labelTime);
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

  /// Get X-axis date/time formatter based on period
  String Function(DateTime) _getXAxisFormatter() {
    switch (selectedPeriod) {
      case '1 hour':
        return (dt) => DateFormat('HH:mm').format(dt);
      case '12 hours':
        return (dt) => DateFormat('H:00').format(dt);
      case '24 hours':
      case '1 day':
        return (dt) => DateFormat('HH:00').format(dt);
      case '1 week':
      case '30 days':
      case '1 month':
        return (dt) => DateFormat('d MMM').format(dt);
      default:
        return (dt) => DateFormat('HH:mm').format(dt);
    }
  }

}
