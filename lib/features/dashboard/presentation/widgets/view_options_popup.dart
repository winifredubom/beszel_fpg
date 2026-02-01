import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Layout options
enum LayoutOption { grid, table }

/// Sort options for systems
enum SortOption {
  systemAsc,
  systemDesc,
  cpuAsc,
  cpuDesc,
  memoryAsc,
  memoryDesc,
  diskAsc,
  diskDesc,
  gpuAsc,
  gpuDesc,
  netWorkAsc,
  netWorkDesc,
  temperatureAsc,
  temperatureDesc,
  agentVersionAsc,
  agentVersionDesc,
}

/// Visible fields that can be toggled
enum VisibleField {
  cpu,
  memory,
  disk,
  gpu,
  network,
  temperature,
  agentVersion,
  actions,
}

/// Provider for layout option
final layoutOptionProvider = StateProvider<LayoutOption>((ref) => LayoutOption.grid);

/// Provider for sort option
final sortOptionProvider = StateProvider<SortOption>((ref) => SortOption.systemAsc);

/// Provider for visible fields
final visibleFieldsProvider = StateProvider<Set<VisibleField>>((ref) => {
  VisibleField.cpu,
  VisibleField.memory,
  VisibleField.disk,
  VisibleField.gpu,
  VisibleField.network,
  VisibleField.temperature,
  VisibleField.agentVersion,
  VisibleField.actions,
});

/// View options popup widget
class ViewOptionsPopup extends ConsumerWidget {
  final VoidCallback onClose;

  const ViewOptionsPopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLayout = ref.watch(layoutOptionProvider);
    final currentSort = ref.watch(sortOptionProvider);
    final visibleFields = ref.watch(visibleFieldsProvider);

    return Container(
      width: 420,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Layout Column
            Expanded(
              child: _buildColumn(
                context: context,
                icon: CupertinoIcons.square_grid_2x2,
                title: 'Layout',
                child: Column(
                  children: [
                    // _buildLayoutOption(
                    //   context: context,
                    //   ref: ref,
                    //   icon: CupertinoIcons.list_bullet,
                    //   label: 'Table',
                    //   option: LayoutOption.table,
                    //   currentOption: currentLayout,
                    //   enabled: false, // Table not implemented yet
                    // ),
                    _buildLayoutOption(
                      context: context,
                      ref: ref,
                      icon: CupertinoIcons.square_grid_2x2,
                      label: 'Grid',
                      option: LayoutOption.grid,
                      currentOption: currentLayout,
                      enabled: true,
                    ),
                  ],
                ),
              ),
            ),
            // Divider
            Container(
              width: 0.5,
              color: context.borderColor,
            ),
            // Sort By Column
            Expanded(
              child: _buildColumn(
                context: context,
                icon: CupertinoIcons.arrow_up_arrow_down,
                title: 'Sort By',
                child: Column(
                  children: [
                    _buildSortOption(context, ref, 'System', SortOption.systemAsc, SortOption.systemDesc, currentSort),
                    _buildSortOption(context, ref, 'CPU', SortOption.cpuAsc, SortOption.cpuDesc, currentSort),
                    _buildSortOption(context, ref, 'Memory', SortOption.memoryAsc, SortOption.memoryDesc, currentSort),
                    _buildSortOption(context, ref, 'Disk', SortOption.diskAsc, SortOption.diskDesc, currentSort),
                    _buildSortOption(context, ref, 'GPU', SortOption.gpuAsc, SortOption.gpuDesc, currentSort),
                    _buildSortOption(context, ref, 'Network', SortOption.netWorkAsc, SortOption.netWorkDesc, currentSort),
                    _buildSortOption(context, ref, 'Temp', SortOption.temperatureAsc, SortOption.temperatureDesc, currentSort),
                    _buildSortOption(context, ref, 'Agent V.', SortOption.agentVersionAsc, SortOption.agentVersionDesc, currentSort),
                  ],
                ),
              ),
            ),
            // Divider
            Container(
              width: 0.5,
              color: context.borderColor,
            ),
            // Visible Fields Column
            Expanded(
              child: _buildColumn(
                context: context,
                icon: CupertinoIcons.eye,
                title: 'Visible Fields',
                child: Column(
                  children: [
                    _buildVisibleFieldOption(context, ref, 'CPU', VisibleField.cpu, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'Memory', VisibleField.memory, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'Disk', VisibleField.disk, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'GPU', VisibleField.gpu, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'Net', VisibleField.network, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'Temp', VisibleField.temperature, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'Agent', VisibleField.agentVersion, visibleFields),
                    _buildVisibleFieldOption(context, ref, 'Actions', VisibleField.actions, visibleFields),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: context.secondaryTextColor,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: context.secondaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildLayoutOption({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String label,
    required LayoutOption option,
    required LayoutOption currentOption,
    required bool enabled,
  }) {
    final isSelected = currentOption == option;
    
    return GestureDetector(
      onTap: enabled
          ? () {
              ref.read(layoutOptionProvider.notifier).state = option;
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? context.backgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: context.textColor,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 14),
            Icon(
              icon,
              size: 14,
              color: enabled ? context.textColor : context.secondaryTextColor.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: enabled ? context.textColor : context.secondaryTextColor.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    SortOption ascOption,
    SortOption descOption,
    SortOption currentSort,
  ) {
    final isAscSelected = currentSort == ascOption;
    final isDescSelected = currentSort == descOption;
    final isSelected = isAscSelected || isDescSelected;

    return GestureDetector(
      onTap: () {
        // Toggle between asc and desc, or select desc by default
        if (isAscSelected) {
          ref.read(sortOptionProvider.notifier).state = descOption;
        } else {
          ref.read(sortOptionProvider.notifier).state = ascOption;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? context.backgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isAscSelected
                  ? CupertinoIcons.arrow_up
                  : isDescSelected
                      ? CupertinoIcons.arrow_down
                      : CupertinoIcons.arrow_down,
              size: 12,
              color: isSelected ? context.textColor : context.secondaryTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: context.textColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibleFieldOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    VisibleField field,
    Set<VisibleField> visibleFields,
  ) {
    final isVisible = visibleFields.contains(field);

    return GestureDetector(
      onTap: () {
        final currentFields = ref.read(visibleFieldsProvider);
        final newFields = Set<VisibleField>.from(currentFields);
        if (isVisible) {
          newFields.remove(field);
        } else {
          newFields.add(field);
        }
        ref.read(visibleFieldsProvider.notifier).state = newFields;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isVisible ? CupertinoIcons.checkmark : null,
              size: 14,
              color: context.textColor,
            ),
            SizedBox(width: isVisible ? 8 : 22),
            Text(
              label,
              style: TextStyle(
                color: context.textColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show view options popup
void showViewOptionsPopup(BuildContext context, GlobalKey buttonKey) {
  final RenderBox? renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final buttonPosition = renderBox.localToGlobal(Offset.zero);
  final buttonSize = renderBox.size;

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Tap outside to close
        Positioned.fill(
          child: GestureDetector(
            onTap: () => overlayEntry.remove(),
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
        // Popup positioned below the button
        Positioned(
          top: buttonPosition.dy + buttonSize.height + 8,
          right: MediaQuery.of(context).size.width - buttonPosition.dx - buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Consumer(
              builder: (context, ref, child) => ViewOptionsPopup(
                onClose: () => overlayEntry.remove(),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}
