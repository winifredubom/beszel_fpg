import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class ServerHeader extends StatelessWidget {
  final String title;
  final String status;
  final String ipAddress;
  final String hostname;
  final String uptime;
  final String version;
  final String serverType;

  const ServerHeader({
    super.key,
    required this.title,
    required this.status,
    required this.ipAddress,
    required this.hostname,
    required this.uptime,
    required this.version,
    required this.serverType,
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
            // Title and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                      fontFamily: '.SF Pro Display',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: TextStyle(
                          color: context.surfaceColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: '.SF Pro Text',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Server Details
            Wrap(
              spacing: AppDimensions.paddingL,
              runSpacing: AppDimensions.paddingS,
              children: [
                _buildInfoItem(CupertinoIcons.globe, ipAddress, context),
                _buildInfoItem(CupertinoIcons.device_desktop, hostname, context),
                _buildInfoItem(CupertinoIcons.clock, uptime, context),
                _buildInfoItem(CupertinoIcons.info_circle, version, context),
                _buildInfoItem(CupertinoIcons.square_stack_3d_up, serverType, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Theme.of(context).brightness == Brightness.dark
              ? context.secondaryTextColor
              : context.secondaryTextColor,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? context.secondaryTextColor
                : context.secondaryTextColor,
            fontSize: 14,
            fontFamily: '.SF Pro Text',
          ),
        ),
      ],
    );
  }
}
