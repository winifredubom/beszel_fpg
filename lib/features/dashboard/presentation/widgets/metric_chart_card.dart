import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_extensions.dart';

class MetricChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentValue;
  final String maxValue;
  final Color chartColor;
  final List<double> data;
  final bool hasFilter;
  final bool showAreaChart;

  const MetricChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.maxValue,
    required this.chartColor,
    required this.data,
    this.hasFilter = false,
    this.showAreaChart = false,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(
              currentValue,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: chartColor,
                fontFamily: '.SF Pro Display',
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Chart Area
            SizedBox(
              height: AppDimensions.chartHeight,
              child: CustomPaint(
                size: const Size(double.infinity, AppDimensions.chartHeight),
                painter: showAreaChart 
                    ? AreaChartPainter(
                        data: data,
                        color: chartColor,
                      )
                    : LineChartPainter(
                        data: data,
                        color: chartColor,
                      ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Time labels (mock)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '10:40',
                  style: TextStyle(
                    color: context.secondaryTextColor,
                    fontSize: 12,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                Text(
                  '10:50',
                  style: TextStyle(
                    color: context.secondaryTextColor,
                    fontSize: 12,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                Text(
                  '11:00',
                  style: TextStyle(
                    color: context.secondaryTextColor,
                    fontSize: 12,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                Text(
                  '11:10',
                  style: TextStyle(
                    color: context.secondaryTextColor,
                    fontSize: 12,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                Text(
                  '11:20',
                  style: TextStyle(
                    color: context.secondaryTextColor,
                    fontSize: 12,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                Text(
                  '11:30',
                  style: TextStyle(
                    color: context.secondaryTextColor,
                    fontSize: 12,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  LineChartPainter({
    required this.data,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AreaChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  AreaChartPainter({
    required this.data,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final strokePath = Path();
    
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final valueRange = maxValue - minValue;
    
    if (valueRange == 0) {
      // Draw a filled rectangle if all values are the same
      path.addRect(Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2));
      strokePath.moveTo(0, size.height / 2);
      strokePath.lineTo(size.width, size.height / 2);
    } else {
      // Start from bottom left
      path.moveTo(0, size.height);
      strokePath.moveTo(0, size.height - ((data[0] - minValue) / valueRange * size.height));
      
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
