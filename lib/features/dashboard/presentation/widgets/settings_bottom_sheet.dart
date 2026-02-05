import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/providers/pinned_servers_provider.dart';

class SettingsBottomSheet extends ConsumerWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedServers = ref.watch(pinnedServersProvider);
    final responsive = Responsive(context);
    
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, _) {
        final isDarkMode = context.isDarkMode;
        
        return Container(
          constraints: BoxConstraints(
            maxHeight: responsive.screenHeight * responsive.bottomSheetMaxHeightFactor,
            maxWidth: responsive.isMobile ? double.infinity : 500,
          ),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32), // Spacer for centering
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textColor,
                        fontFamily: '.SF Pro Display',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.grey[700]
                              : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.xmark,
                          size: 16,
                          color: isDarkMode 
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Section
                      _buildSectionHeader(context, 'Display'),
                      const SizedBox(height: 8),
                      _buildSettingsCard(
                        context,
                        isDarkMode,
                        children: [
                          _buildSettingsRow(
                            context,
                            label: 'Language',
                            value: 'English',
                            showChevron: false ,
                            isEnabled: false,
                          ),
                          _buildDivider(context, isDarkMode),
                          _buildSettingsRow(
                            context,
                            label: 'Chart period',
                            value: 'Last hour',
                            showChevron: false,
                            isEnabled: false,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Pinned Servers Section
                      _buildSectionHeader(context, 'Pinned Servers'),
                      const SizedBox(height: 8),
                      if (pinnedServers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            'No pinned servers',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.secondaryTextColor,
                              fontFamily: '.SF Pro Text',
                            ),
                          ),
                        )
                      else
                        _buildSettingsCard(
                          context,
                          isDarkMode,
                          children: [
                            ...pinnedServers.asMap().entries.map((entry) {
                              final index = entry.key;
                              final server = entry.value;
                              return Column(
                                children: [
                                  _buildPinnedServerRow(
                                    context,
                                    ref,
                                    name: server.name,
                                    serverId: server.id,
                                  ),
                                  if (index < pinnedServers.length - 1)
                                    _buildDivider(context, isDarkMode),
                                ],
                              );
                            }),
                          ],
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // Dashboard Section
                      _buildSectionHeader(context, 'Dashboard'),
                      const SizedBox(height: 8),
                      _buildSettingsCard(
                        context,
                        isDarkMode,
                        children: [
                          _buildActionRow(
                            context,
                            label: 'Clear all pins',
                            color: pinnedServers.isEmpty 
                                ? context.secondaryTextColor 
                                : CupertinoColors.destructiveRed,
                            onTap: pinnedServers.isEmpty 
                                ? null 
                                : () {
                                    ref.read(pinnedServersProvider.notifier).clearAllPins();
                                    Navigator.of(context).pop();
                                  },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: context.secondaryTextColor,
          fontFamily: '.SF Pro Text',
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    bool isDarkMode, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required String label,
    required String value,
    bool showChevron = false,
    bool isEnabled = true,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.textColor,
                fontFamily: '.SF Pro Text',
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: context.secondaryTextColor,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                if (showChevron) ...[
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.chevron_up_chevron_down,
                    size: 14,
                    color: context.secondaryTextColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context, {
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: '.SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedServerRow(
    BuildContext context,
    WidgetRef ref, {
    required String name,
    required String serverId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.pin_fill,
            size: 16,
            color: CupertinoColors.activeBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.textColor,
                fontFamily: '.SF Pro Text',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(pinnedServersProvider.notifier).unpinServer(serverId);
            },
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              size: 20,
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: context.borderColor,
      ),
    );
  }
}
