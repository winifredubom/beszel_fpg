// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/features/dashboard/data/models/system_records_model.dart';
import 'package:beszel_fpg/features/dashboard/data/service/system_records.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../widgets/system_card.dart';
import '../widgets/add_system_dialog.dart';
import '../widgets/custom_app_bar.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _filterText = '';
    final systemRecordsAsync = ref.watch(systemRecordsProvider);

    List<SystemRecordItem> filteredItems = [];
    systemRecordsAsync.whenData((data) {
      filteredItems = _filterText.isEmpty
          ? data.items
          : data.items
                .where(
                  (item) => item.name.toLowerCase().contains(
                    _filterText.toLowerCase(),
                  ),
                )
                .toList();
    });

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
                            // Refresh the provider
                            ref.invalidate(systemRecordsProvider);
                            // Wait for the new data to load
                            await ref.read(systemRecordsProvider.future);
                          },
                        ),
                        // Add top padding to account for floating app bar
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                        SliverPadding(
                          padding: const EdgeInsets.all(AppDimensions.paddingL),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
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
                                                color:
                                                    context.secondaryTextColor,
                                              ),
                                              style: TextStyle(
                                                color: context.textColor,
                                              ),
                                              decoration: null,
                                              padding: EdgeInsets.zero,
                                              onChanged: (value) {
                                                // You need to use a StateProvider for _filterText
                                                //ref.read(filterTextProvider.notifier).state = value;
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
                              systemRecordsAsync.when(
                                loading: () => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                error: (e, stack) =>
                                    Center(child: Text('Error: $e')),
                                data: (_) => Column(
                                  children: filteredItems
                                      .map(
                                        (item) => SystemCard(
                                          title: item.name,
                                          isOnline: item.status == 'online',
                                          cpuUsage: item.info.cpu,
                                          memoryUsage: item.info.m != null
                                              ? double.tryParse(item.info.m) ??
                                                    0
                                              : 0,
                                          diskUsage: item.info.dp,
                                          gpuUsage: 0, // Map as needed
                                          networkUsage: '', // Map as needed
                                          temperature: '', // Map as needed
                                          agentVersion: item.info.v,
                                          onTap: () {
                                            context.go(
                                              '${AppRoutes.systemsBoard}?systemId=${item.id}',
                                            );
                                          },
                                          onNotificationTap: () {
                                            print(
                                              'Notification for ${item.name}',
                                            );
                                          },
                                          onMenuTap: () {
                                            print('Menu for ${item.name}');
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
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
