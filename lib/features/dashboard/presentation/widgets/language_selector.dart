// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/language/language_manager.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_manager.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageManager.instance,
      builder: (context, _) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showLanguageSelector(context);
          },
          child: ListenableBuilder(
            listenable: ThemeManager.instance,
            builder: (context, _) {
              final isDarkMode = ThemeManager.instance.isDarkMode;
              return Icon(
                Icons.translate,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 20,
              );
            },
          ),
        );
      }
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.maxFinite,
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: LanguageManager.supportedLocales.entries.map((entry) {
                  final localeCode = entry.key.split('_');
                  return _buildLanguageItem(
                    context,
                    entry.value['nativeName']!,
                    localeCode[1],
                    () {
                      LanguageManager.instance.setLocale(localeCode[0], localeCode[1]);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, String language, String code, VoidCallback onSelect) {
    final isSelected = LanguageManager.instance.currentLocale.countryCode == code;
    
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPressed: onSelect,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code,
            style: TextStyle(
              color: context.textColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            language,
            style: TextStyle(
              color: context.textColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.check_mark,
              color: context.textColor,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }
}
