import 'package:flutter/cupertino.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class SystemCard extends StatelessWidget {
  const SystemCard({
    super.key,
    required this.title,
    required this.isOnline,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.gpuUsage,
    required this.networkUsage,
    this.temperature,
    required this.agentVersion,
    this.onTap,
    this.onNotificationTap,
    this.onMenuTap,
  });

  final String title;
  final bool isOnline;
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final double gpuUsage;
  final String networkUsage;
  final String? temperature;
  final String agentVersion;
  final VoidCallback? onTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: context.borderColor,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title, status, and actions
            Row(
              children: [
                // Status indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOnline ? AppColors.success : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: context.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Notification button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onNotificationTap,
                  child: Icon(
                    CupertinoIcons.bell,
                    color: context.textColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 4),
                // Menu button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onMenuTap,
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    color: context.textColor,
                    size: 18,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Metrics
            Column(
              children: [
                _buildMetricRow(
                  context,
                  CupertinoIcons.device_laptop,
                  'CPU:',
                  '${cpuUsage.toStringAsFixed(1)}%',
                  cpuUsage,
                  AppColors.cpuColor,
                ),
                const SizedBox(height: 8),
                _buildMetricRow(
                  context,
                  CupertinoIcons.memories,
                  'Memory:',
                  '${memoryUsage.toStringAsFixed(1)}%',
                  memoryUsage,
                  AppColors.memoryColor,
                ),
                const SizedBox(height: 8),
                _buildMetricRow(
                  context,
                  CupertinoIcons.device_laptop,
                  'Disk:',
                  '${diskUsage.toStringAsFixed(1)}%',
                  diskUsage,
                  _getDiskColor(diskUsage),
                ),
                const SizedBox(height: 8),
                _buildMetricRow(
                  context,
                  CupertinoIcons.tv,
                  'GPU:',
                  '${gpuUsage.toStringAsFixed(1)}%',
                  gpuUsage,
                  AppColors.secondaryColor,
                ),
                const SizedBox(height: 8),
                _buildMetricRowText(
                  context,
                  CupertinoIcons.wifi,
                  'Net:',
                  networkUsage,
                ),
                if (temperature != null) ...[
                  const SizedBox(height: 8),
                  _buildMetricRowText(
                    context,
                    CupertinoIcons.thermometer,
                    'Temp:',
                    temperature!,
                  ),
                ],
                const SizedBox(height: 8),
                _buildAgentRow(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    double percentage,
    Color barColor,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: context.secondaryTextColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              color: context.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 50,
          child: Text(
            value,
            style: TextStyle(
              color: context.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRowText(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: context.secondaryTextColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              color: context.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            color: context.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAgentRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.wifi,
          color: context.secondaryTextColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            'Agent:',
            style: TextStyle(
              color: context.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          agentVersion,
          style: TextStyle(
            color: context.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getDiskColor(double usage) {
    if (usage < 50) return AppColors.success;
    if (usage < 80) return AppColors.warning;
    return AppColors.error;
  }
}
