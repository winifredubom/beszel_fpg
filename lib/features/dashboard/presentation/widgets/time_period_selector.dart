import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class TimePeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  static const List<String> periods = [
    '1 hour',
    '6 hours',
    '12 hours',
    '24 hours',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.clock,
          color: context.textColor,
          size: 20,
        ),
        const SizedBox(width: AppDimensions.paddingS),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            onPressed: () {
              _showPicker(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedPeriod,
                  style:  TextStyle(
                    color: context.textColor,
                    fontSize: 14,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
                const SizedBox(width: 8),
                 Icon(
                  CupertinoIcons.chevron_down,
                  color: context.textColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem: periods.indexOf(selectedPeriod),
            ),
            onSelectedItemChanged: (int selectedItem) {
              onPeriodChanged(periods[selectedItem]);
            },
            children: List<Widget>.generate(periods.length, (int index) {
              return Center(
                child: Text(
                  periods[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
