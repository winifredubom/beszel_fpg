// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Configuration for chart axis based on time period
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

  /// Get axis configuration based on selected time period
  static ChartAxisConfig forPeriod(String period) {
    switch (period) {
      case '1 hour':
        return ChartAxisConfig(
          yAxisInterval: 0.4, // 0%, 0.4%, 0.8%, 1.2%, etc.
          xAxisLabelCount: 6,
          xAxisInterval: const Duration(minutes: 5),
          xAxisFormatter: (dt) => DateFormat('HH:mm').format(dt),
        );
      case '3 hours':
        return ChartAxisConfig(
          yAxisInterval: 0.3,
          xAxisLabelCount: 6,
          xAxisInterval: const Duration(minutes: 30),
          xAxisFormatter: (dt) => DateFormat('HH:mm').format(dt),
        );
      case '6 hours':
        return ChartAxisConfig(
          yAxisInterval: 0.3,
          xAxisLabelCount: 6,
          xAxisInterval: const Duration(hours: 1),
          xAxisFormatter: (dt) => DateFormat('HH:mm').format(dt),
        );
      case '12 hours':
        return ChartAxisConfig(
          yAxisInterval: 0.3, // 0%, 0.3%, 0.6%, 0.9%, etc.
          xAxisLabelCount: 6,
          xAxisInterval: const Duration(hours: 1),
          xAxisFormatter: (dt) => DateFormat('H:00').format(dt),
        );
      case '24 hours':
      case '1 day':
        return ChartAxisConfig(
          yAxisInterval: 0.3, // 0%, 0.3%, 0.6%, 0.9%, etc.
          xAxisLabelCount: 8,
          xAxisInterval: const Duration(hours: 3),
          xAxisFormatter: (dt) => DateFormat('HH:00').format(dt),
        );
      case '1 week':
        return ChartAxisConfig(
          yAxisInterval: 0.25, // 0%, 0.25%, 0.5%, 0.75%, etc.
          xAxisLabelCount: 7,
          xAxisInterval: const Duration(days: 1),
          xAxisFormatter: (dt) => DateFormat('d MMM').format(dt),
        );
      case '30 days':
      case '1 month':
        return ChartAxisConfig(
          yAxisInterval: 0.3, // 0%, 0.3%, 0.6%, etc.
          xAxisLabelCount: 8,
          xAxisInterval: const Duration(days: 2),
          xAxisFormatter: (dt) => DateFormat('d MMM').format(dt),
        );
      default:
        return ChartAxisConfig(
          yAxisInterval: 0.4,
          xAxisLabelCount: 6,
          xAxisInterval: const Duration(minutes: 10),
          xAxisFormatter: (dt) => DateFormat('HH:mm').format(dt),
        );
    }
  }
}

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
  final String unit; // e.g., '%', 'GB', 'MB/s'

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
  });

  @override
  Widget build(BuildContext context) {
    final axisConfig = ChartAxisConfig.forPeriod(selectedPeriod);
    
    // Generate time labels based on period
    final timeLabels = _generateTimeLabels(axisConfig);
    
    // Generate Y-axis labels based on data range
    final yAxisLabels = _generateYAxisLabels(axisConfig);
    
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
            Row(
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
                if (hasFilter)
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    onPressed: () {
                      // Handle filter action
                    },
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
                  ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Current Value Display
            // Text(
            //   currentValue,
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: chartColor,
            //     fontFamily: '.SF Pro Display',
            //   ),
            // ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Chart Area with Y-axis
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis labels
                SizedBox(
                  width: 40,
                  height: AppDimensions.chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: yAxisLabels.reversed.map((label) {
                      return Text(
                        label,
                        style: TextStyle(
                          color: context.secondaryTextColor,
                          fontSize: 10,
                          fontFamily: '.SF Pro Text',
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                // Chart
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.chartHeight,
                    child: CustomPaint(
                      size: const Size(double.infinity, AppDimensions.chartHeight),
                      painter: showAreaChart 
                          ? AreaChartPainter(
                              data: data,
                              color: chartColor,
                              yAxisLabels: yAxisLabels,
                            )
                          : LineChartPainter(
                              data: data,
                              color: chartColor,
                              yAxisLabels: yAxisLabels,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingS),
            
            // Time labels (X-axis)
            Padding(
              padding: const EdgeInsets.only(left: 48), // Align with chart
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: timeLabels.map((label) {
                  return Text(
                    label,
                    style: TextStyle(
                      color: context.secondaryTextColor,
                      fontSize: 10,
                      fontFamily: '.SF Pro Text',
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate Y-axis labels based on data range and axis config
  List<String> _generateYAxisLabels(ChartAxisConfig config) {
    if (data.isEmpty) {
      return ['0$unit'];
    }
    
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = 0.0; // Always start from 0
    
    // Calculate nice round max value for the axis
    double axisMax;
    if (maxValue <= 1) {
      axisMax = 1.0;
    } else if (maxValue <= 5) {
      axisMax = 5.0;
    } else if (maxValue <= 10) {
      axisMax = 10.0;
    } else if (maxValue <= 25) {
      axisMax = 25.0;
    } else if (maxValue <= 50) {
      axisMax = 50.0;
    } else if (maxValue <= 100) {
      axisMax = 100.0;
    } else {
      axisMax = (maxValue / 10).ceil() * 10.0;
    }
    
    // Generate labels based on the interval from config
    final labels = <String>[];
    
    // Calculate number of labels based on y-axis interval
    int labelCount;
    switch (selectedPeriod) {
      case '1 hour':
        labelCount = (axisMax / config.yAxisInterval).ceil().clamp(3, 6);
        break;
      case '12 hours':
        labelCount = (axisMax / config.yAxisInterval).ceil().clamp(3, 6);
        break;
      case '24 hours':
      case '1 day':
        labelCount = (axisMax / config.yAxisInterval).ceil().clamp(3, 6);
        break;
      case '1 week':
        labelCount = (axisMax / config.yAxisInterval).ceil().clamp(3, 5);
        break;
      case '30 days':
      case '1 month':
        labelCount = (axisMax / config.yAxisInterval).ceil().clamp(3, 6);
        break;
      default:
        labelCount = 5;
    }
    
    final step = axisMax / labelCount;
    
    for (int i = 0; i <= labelCount; i++) {
      final value = minValue + (step * i);
      if (value == value.toInt()) {
        labels.add('${value.toInt()}$unit');
      } else {
        labels.add('${value.toStringAsFixed(1)}$unit');
      }
    }
    
    return labels;
  }

  /// Generate time labels based on period and timestamps
  List<String> _generateTimeLabels(ChartAxisConfig config) {
    final now = DateTime.now();
    final labels = <String>[];
    
    // If we have actual timestamps, use them
    if (timestamps != null && timestamps!.isNotEmpty) {
      final startTime = timestamps!.first;
      final endTime = timestamps!.last;
      final totalDuration = endTime.difference(startTime);
      final labelCount = config.xAxisLabelCount;
      
      for (int i = 0; i < labelCount; i++) {
        final progress = i / (labelCount - 1);
        final labelTime = startTime.add(
          Duration(milliseconds: (totalDuration.inMilliseconds * progress).round()),
        );
        labels.add(config.xAxisFormatter(labelTime));
      }
      return labels;
    }
    
    // Otherwise, generate based on period
    Duration totalDuration;
    switch (selectedPeriod) {
      case '1 hour':
        totalDuration = const Duration(hours: 1);
        break;
      case '3 hours':
        totalDuration = const Duration(hours: 3);
        break;
      case '6 hours':
        totalDuration = const Duration(hours: 6);
        break;
      case '12 hours':
        totalDuration = const Duration(hours: 12);
        break;
      case '24 hours':
      case '1 day':
        totalDuration = const Duration(days: 1);
        break;
      case '1 week':
        totalDuration = const Duration(days: 7);
        break;
      case '30 days':
      case '1 month':
        totalDuration = const Duration(days: 30);
        break;
      default:
        totalDuration = const Duration(hours: 1);
    }
    
    final startTime = now.subtract(totalDuration);
    final labelCount = config.xAxisLabelCount;
    
    for (int i = 0; i < labelCount; i++) {
      final progress = i / (labelCount - 1);
      final labelTime = startTime.add(
        Duration(milliseconds: (totalDuration.inMilliseconds * progress).round()),
      );
      labels.add(config.xAxisFormatter(labelTime));
    }
    
    return labels;
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final List<String>? yAxisLabels;

  LineChartPainter({
    required this.data,
    required this.color,
    this.yAxisLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    _drawGridLines(canvas, size);

    final path = Path();
    
    // Calculate the max value from Y-axis labels or data
    double maxValue;
    if (yAxisLabels != null && yAxisLabels!.isNotEmpty) {
      // Parse the max value from the last label
      final lastLabel = yAxisLabels!.last;
      final numericPart = lastLabel.replaceAll(RegExp(r'[^0-9.]'), '');
      maxValue = double.tryParse(numericPart) ?? data.reduce((a, b) => a > b ? a : b);
    } else {
      maxValue = data.reduce((a, b) => a > b ? a : b);
    }
    
    final minValue = 0.0; // Always start from 0
    final valueRange = maxValue - minValue;
    
    if (valueRange == 0) {
      // Draw a straight line if all values are the same
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
    } else {
      for (int i = 0; i < data.length; i++) {
        final x = (i / (data.length - 1)) * size.width;
        final normalizedValue = (data[i] - minValue) / valueRange;
        final y = size.height - (normalizedValue * size.height);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines based on Y-axis labels count
    final horizontalLines = (yAxisLabels?.length ?? 6) - 1;
    for (int i = 0; i <= horizontalLines; i++) {
      final y = (i / horizontalLines) * size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AreaChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final List<String>? yAxisLabels;

  AreaChartPainter({
    required this.data,
    required this.color,
    this.yAxisLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Draw grid lines first
    _drawGridLines(canvas, size);

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final strokePath = Path();
    
    // Calculate the max value from Y-axis labels or data
    double maxValue;
    if (yAxisLabels != null && yAxisLabels!.isNotEmpty) {
      final lastLabel = yAxisLabels!.last;
      final numericPart = lastLabel.replaceAll(RegExp(r'[^0-9.]'), '');
      maxValue = double.tryParse(numericPart) ?? data.reduce((a, b) => a > b ? a : b);
    } else {
      maxValue = data.reduce((a, b) => a > b ? a : b);
    }
    
    final minValue = 0.0;
    final valueRange = maxValue - minValue;
    
    if (valueRange == 0) {
      // Draw a filled rectangle if all values are the same
      path.addRect(Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2));
      strokePath.moveTo(0, size.height / 2);
      strokePath.lineTo(size.width, size.height / 2);
    } else {
      // Start from bottom left
      path.moveTo(0, size.height);
      
      final firstNormalized = (data[0] - minValue) / valueRange;
      final firstY = size.height - (firstNormalized * size.height);
      strokePath.moveTo(0, firstY);
      
      for (int i = 0; i < data.length; i++) {
        final x = (i / (data.length - 1)) * size.width;
        final normalizedValue = (data[i] - minValue) / valueRange;
        final y = size.height - (normalizedValue * size.height);
        
        if (i == 0) {
          path.lineTo(x, y);
        } else {
          path.lineTo(x, y);
          strokePath.lineTo(x, y);
        }
      }
      
      // Close the path at bottom right
      path.lineTo(size.width, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(strokePath, strokePaint);
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines based on Y-axis labels count
    final horizontalLines = (yAxisLabels?.length ?? 6) - 1;
    for (int i = 0; i <= horizontalLines; i++) {
      final y = (i / horizontalLines) * size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
