// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/features/dashboard/data/service/system_records.dart';
import 'package:beszel_fpg/features/dashboard/data/providers/pinned_servers_provider.dart';
import 'package:beszel_fpg/core/network/realtime_service.dart';
import 'package:beszel_fpg/core/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../widgets/system_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_options_popup.dart';

/// Provider for filter text state
final filterTextProvider = StateProvider<String>((ref) => '');

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> with WidgetsBindingObserver {
  final GlobalKey _viewButtonKey = GlobalKey();
  late final RealtimeService _realtimeService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Save reference to realtime service before potential dispose
    _realtimeService = ref.read(realtimeServiceProvider);
    // Connect to realtime on page load
    _connectRealtime();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Use saved reference instead of ref.read() which is unsafe in dispose
   // _realtimeService.disconnect();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reconnect when app comes to foreground
      if (!_realtimeService.isConnected) {
        _connectRealtime();
      }
    } else if (state == AppLifecycleState.paused) {
      // Disconnect when app goes to background (save battery)
      _realtimeService.disconnect();
    }
  }

  void _connectRealtime() {
    if (!_realtimeService.isConnected) {
      _realtimeService.connect().catchError((e) {
        debugPrint('❌ Failed to connect realtime: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the live realtime stream
    final liveSystemsAsync = ref.watch(liveSystemRecordsProvider);
    final realtimeConnection = ref.watch(realtimeConnectionProvider);
    final filterText = ref.watch(filterTextProvider);
    final sortOption = ref.watch(sortOptionProvider);
    final visibleFields = ref.watch(visibleFieldsProvider);
    final pinnedServers = ref.watch(pinnedServersProvider);

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
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            // Reconnect realtime and refresh
                            final realtimeService = ref.read(realtimeServiceProvider);
                            await realtimeService.reconnect();
                          },
                        ),
                        // Add top padding to account for floating app bar
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.horizontalPadding,
                            vertical: AppDimensions.paddingL,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // All Systems Header
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'All Systems',
                                        style: TextStyle(
                                          color: context.textColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Realtime connection indicator
                                      realtimeConnection.when(
                                        data: (connected) => Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: connected ? Colors.green : Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        loading: () => const SizedBox(
                                          width: 8,
                                          height: 8,
                                          child: CupertinoActivityIndicator(radius: 4),
                                        ),
                                        error: (_, __) => Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                                color:
                                                    context.secondaryTextColor,
                                              ),
                                              style: TextStyle(
                                                color: context.textColor,
                                              ),
                                              decoration: null,
                                              padding: EdgeInsets.zero,
                                              onChanged: (value) {
                                                ref.read(filterTextProvider.notifier).state = value;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // View toggle button
                                  GestureDetector(
                                    key: _viewButtonKey,
                                    onTap: () {
                                      showViewOptionsPopup(context, _viewButtonKey);
                                    },
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.slider_horizontal_3,
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
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.paddingL),
                              // Systems List - Now using realtime stream
                              liveSystemsAsync.when(
                                loading: () => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                error: (e, stack) =>
                                    Center(child: Text('Error: $e')),
                                data: (items) {
                                  // Filter systems based on filter text
                                  var filteredItems = filterText.isEmpty
                                      ? items.toList()
                                      : items
                                          .where((item) => item.name
                                              .toLowerCase()
                                              .contains(filterText.toLowerCase()))
                                          .toList();
                                  
                                  // Get pinned server IDs for sorting
                                  final pinnedIds = pinnedServers.map((s) => s.id).toSet();
                                  
                                  // Sort systems: pinned first, then by sort option
                                  filteredItems.sort((a, b) {
                                    // First, sort by pinned status
                                    final aIsPinned = pinnedIds.contains(a.id);
                                    final bIsPinned = pinnedIds.contains(b.id);
                                    if (aIsPinned && !bIsPinned) return -1;
                                    if (!aIsPinned && bIsPinned) return 1;
                                    
                                    // Then apply the selected sort option
                                    switch (sortOption) {
                                      case SortOption.systemAsc:
                                        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                                      case SortOption.systemDesc:
                                        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
                                      case SortOption.cpuAsc:
                                        return a.info.cpu.compareTo(b.info.cpu);
                                      case SortOption.cpuDesc:
                                        return b.info.cpu.compareTo(a.info.cpu);
                                      case SortOption.memoryAsc:
                                        return a.info.mp.compareTo(b.info.mp);
                                      case SortOption.memoryDesc:
                                        return b.info.mp.compareTo(a.info.mp);
                                      case SortOption.diskAsc:
                                        return a.info.dp.compareTo(b.info.dp);
                                      case SortOption.diskDesc:
                                        return b.info.dp.compareTo(a.info.dp);
                                      case SortOption.gpuAsc:
                                        return a.info.os.compareTo(a.info.os); 
                                      case SortOption.gpuDesc:
                                        return b.info.os.compareTo(b.info.os); 
                                      case SortOption.netWorkAsc:
                                        return a.info.u.compareTo(b.info.u); 
                                      case SortOption.netWorkDesc:
                                        return b.info.u.compareTo(b.info.u);
                                      case SortOption.temperatureAsc:
                                        return a.info.t.compareTo(b.info.t);    
                                      case SortOption.temperatureDesc:
                                        return b.info.t.compareTo(a.info.t);
                                      case SortOption.agentVersionAsc:
                                        return a.info.v.compareTo(b.info.v);  
                                      case SortOption.agentVersionDesc:
                                        return b.info.v.compareTo(a.info.v);           
                                    }
                                  });
                                  
                                  if (filteredItems.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Text(
                                          filterText.isEmpty
                                              ? 'No systems found'
                                              : 'No systems matching "$filterText"',
                                          style: TextStyle(
                                            color: context.secondaryTextColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  // Build system cards
                                  final systemCards = filteredItems.map(
                                    (item) => SystemCard(
                                      title: item.name,
                                      isOnline: item.status == 'online' || item.status == 'up',
                                      cpuUsage: item.info.cpu,
                                      memoryUsage: item.info.mp,
                                      diskUsage: item.info.dp,
                                      gpuUsage: 0, // Map as needed
                                      networkUsage: '', // Map as needed
                                      temperature: '', // Map as needed
                                      agentVersion: item.info.v,
                                      isPinned: pinnedIds.contains(item.id),
                                      showCpu: visibleFields.contains(VisibleField.cpu),
                                      showMemory: visibleFields.contains(VisibleField.memory),
                                      showDisk: visibleFields.contains(VisibleField.disk),
                                      showGpu: visibleFields.contains(VisibleField.gpu),
                                      showNetwork: visibleFields.contains(VisibleField.network),
                                      showTemperature: visibleFields.contains(VisibleField.temperature),
                                      showAgentVersion: visibleFields.contains(VisibleField.agentVersion),
                                      showActions: visibleFields.contains(VisibleField.actions),
                                      onTap: () {
                                        debugPrint('🚀 Navigating to system: ${item.id}');
                                        debugPrint('🚀 Full path: ${AppRoutes.systemsBoard}?systemId=${item.id}');
                                        context.push(
                                          '${AppRoutes.systemsBoard}?systemId=${item.id}',
                                        );
                                      },
                                      onNotificationTap: () {
                                        debugPrint(
                                          'Notification for ${item.name}',
                                        );
                                      },
                                      onMenuTap: () {
                                        debugPrint('Menu for ${item.name}');
                                      },
                                      onPinTap: () {
                                        ref.read(pinnedServersProvider.notifier)
                                            .togglePin(item.id, item.name);
                                      },
                                    ),
                                  ).toList();
                                  
                                  // Use responsive layout
                                  return ResponsiveBuilder(
                                    builder: (context, responsive) {
                                      // On mobile, use simple column
                                      if (responsive.isMobile) {
                                        return Column(children: systemCards);
                                      }
                                      
                                      // On tablet/desktop, use grid layout
                                      final columns = responsive.dashboardColumns;
                                      final rows = <Widget>[];
                                      
                                      for (var i = 0; i < systemCards.length; i += columns) {
                                        final rowItems = systemCards.skip(i).take(columns).toList();
                                        rows.add(
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: rowItems.map((card) {
                                                return Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: card,
                                                  ),
                                                );
                                              }).toList()
                                              // Add empty spacers if row is not full
                                              ..addAll(
                                                List.generate(
                                                  columns - rowItems.length,
                                                  (_) => const Expanded(child: SizedBox()),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      
                                      return Column(children: rows);
                                    },
                                  );
                                },
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const CustomAppBar(isFloating: true, canGoBack: false),
                  ],
                ),
              ),
              // Floating Add Button
              // Positioned(
              //   right: 16,
              //   bottom: 16,
              //   child: CupertinoButton(
              //     padding: EdgeInsets.zero,
              //     onPressed: () {
              //       showCupertinoDialog(
              //         context: context,
              //         builder: (context) => const AddSystemDialog(),
              //       );
              //     },
              //     child: Container(
              //       width: 56,
              //       height: 56,
              //       decoration: BoxDecoration(
              //         color: context.backgroundColor,
              //         borderRadius: BorderRadius.circular(28),
              //         boxShadow: [
              //           BoxShadow(
              //             color: ThemeManager.instance.isDarkMode
              //                 ? Colors.black.withOpacity(0.3)
              //                 : Colors.black.withOpacity(0.1),
              //             blurRadius: 8,
              //             offset: const Offset(0, 4),
              //           ),
              //         ],
              //       ),
              //       child: Icon(
              //         CupertinoIcons.add,
              //         color: context.textColor,
              //         size: 24,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
