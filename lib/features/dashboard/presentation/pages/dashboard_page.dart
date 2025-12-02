// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/system_card.dart';
import '../widgets/language_selector.dart';
import '../widgets/profile_popup.dart';
import '../widgets/add_system_dialog.dart';
import '../widgets/custom_app_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _filterText = '';

  // Mock data for systems
  final List<SystemData> _systems = [
    SystemData(
      title: 'CIVIS Demo API DR enviro...',
      isOnline: true,
      cpuUsage: 0.7,
      memoryUsage: 12.8,
      diskUsage: 2.1,
      gpuUsage: 0.0,
      networkUsage: '0.00 MB/s',
      temperature: '',
      agentVersion: '0.12.3',
    ),
    SystemData(
      title: 'CIVIS Demo Email Server',
      isOnline: true,
      cpuUsage: 1.2,
      memoryUsage: 40.6,
      diskUsage: 79.3,
      gpuUsage: 0.0,
      networkUsage: '0.00 MB/s',
      temperature: '',
      agentVersion: '0.9.1',
    ),
    SystemData(
      title: 'CIVIS Frontend UAT',
      isOnline: true,
      cpuUsage: 0.9,
      memoryUsage: 10.6,
      diskUsage: 11.4,
      gpuUsage: 0.0,
      networkUsage: '0.00 MB/s',
      temperature: '',
      agentVersion: '0.11.1',
    ),
    SystemData(
      title: 'CIVIS Pocketbase Server',
      isOnline: true,
      cpuUsage: 3.8,
      memoryUsage: 7.7,
      diskUsage: 17.7,
      gpuUsage: 0.0,
      networkUsage: '0.00 MB/s',
      temperature: '',
      agentVersion: '0.11.1',
    ),
    SystemData(
      title: 'Civis Backend UAT Enviro...',
      isOnline: true,
      cpuUsage: 2.6,
      memoryUsage: 17.5,
      diskUsage: 11.4,
      gpuUsage: 0.0,
      networkUsage: '0.01 MB/s',
      temperature: '',
      agentVersion: '0.9.1',
    ),
    SystemData(
      title: 'Civis frontend UAT Enviro...',
      isOnline: true,
      cpuUsage: 0.5,
      memoryUsage: 10.6,
      diskUsage: 11.4,
      gpuUsage: 0.0,
      networkUsage: '0.00 MB/s',
      temperature: '',
      agentVersion: '0.11.1',
    ),
    SystemData(
      title: 'pocketbase',
      isOnline: true,
      cpuUsage: 3.8,
      memoryUsage: 7.7,
      diskUsage: 17.7,
      gpuUsage: 0.0,
      networkUsage: '0.00 MB/s',
      temperature: '',
      agentVersion: '0.11.1',
    ),
  ];

  List<SystemData> get _filteredSystems {
    if (_filterText.isEmpty) return _systems;
    return _systems.where((system) =>
        system.title.toLowerCase().contains(_filterText.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, child) {
        return CupertinoPageScaffold(
          backgroundColor: context.backgroundColor,
          child: Stack(
            children: [
              SafeArea(
                child: Stack(
                children: [
                  // Main content
                CustomScrollView(
                  slivers: [
                    // Add top padding to account for floating app bar
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            // All Systems Header
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'All Systems',
                                  style: TextStyle(
                                    color: context.textColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Updated in real time. Click on a system to view information.',
                                  style: TextStyle(
                                    color: context.secondaryTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppDimensions.paddingL),
                            
                            // Filter and View Controls
                            Row(
                              children: [
                                // Filter input
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.surfaceColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: context.borderColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.search,
                                          color: context.secondaryTextColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CupertinoTextField(
                                            placeholder: 'Filter...',
                                            placeholderStyle: TextStyle(
                                              color: context.secondaryTextColor,
                                            ),
                                            style: TextStyle(
                                              color: context.textColor,
                                            ),
                                            decoration: null,
                                            padding: EdgeInsets.zero,
                                            onChanged: (value) {
                                              setState(() {
                                                _filterText = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 12),
                                
                                // View toggle button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.surfaceColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: context.borderColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        CupertinoIcons.rectangle_grid_1x2,
                                        color: context.textColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'View',
                                        style: TextStyle(
                                          color: context.textColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppDimensions.paddingL),
                            
                            // Systems List
                            ..._filteredSystems.map((system) => SystemCard(
                              title: system.title,
                              isOnline: system.isOnline,
                              cpuUsage: system.cpuUsage,
                              memoryUsage: system.memoryUsage,
                              diskUsage: system.diskUsage,
                              gpuUsage: system.gpuUsage,
                              networkUsage: system.networkUsage,
                              temperature: system.temperature,
                              agentVersion: system.agentVersion,
                              onTap: () {
                                // Navigate to system details
                                context.go(AppRoutes.systemsBoard);
                              },
                              onNotificationTap: () {
                                // Handle notification
                                print('Notification for ${system.title}');
                              },
                              onMenuTap: () {
                                // Show menu
                                print('Menu for ${system.title}');
                              },
                            )).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const CustomAppBar(
                  isFloating: true,
                  canGoBack: false,
                ),
                  ],
                ),
              ),
              // Floating Add Button
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
        );
      },
    );
  }
}

// Data model for system information
class SystemData {
  final String title;
  final bool isOnline;
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final double gpuUsage;
  final String networkUsage;
  final String? temperature;
  final String agentVersion;

  SystemData({
    required this.title,
    required this.isOnline,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.gpuUsage,
    required this.networkUsage,
    this.temperature,
    required this.agentVersion,
  });
}
