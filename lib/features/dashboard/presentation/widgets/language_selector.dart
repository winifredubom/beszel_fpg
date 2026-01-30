// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/language/language_manager.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../dashboard/data/service/dashboard_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  static const Map<String, String> _localeAssetUrls = {
    // Map full locale codes (language_country) to asset URLs.
    // Example provided:
    'de_DE': 'https://beszel.flexipgroup.com/assets/de-BuT7B2oz.js',
    // TODO: Add more locales here as they become available.
  };

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
              return Icon(Icons.translate, color: context.textColor, size: 20);
            },
          ),
        );
      },
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
              child: Consumer(
                builder: (context, ref, _) {
                  final manifestAsync = ref.watch(languageAssetsManifestProvider);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: LanguageManager.supportedLocales.entries.map((
                      entry,
                    ) {
                      final parts = entry.key.split('_');
                      final fullCode = entry.key; // e.g., de_DE
                      return _buildLanguageItem(
                        context,
                        ref,
                        entry.value['nativeName']!,
                        parts[1],
                        () async {
                          // Try manifest first (if loaded), fallback to static mapping
                          String? assetUrl;
                          final manifest = manifestAsync.asData?.value ?? {};
                          assetUrl = manifest[fullCode] ?? _localeAssetUrls[fullCode];
                          if (assetUrl != null) {
                            try {
                              final translations = await ref.read(
                                translationsProvider(assetUrl).future,
                              );
                              LanguageManager.instance.setTranslations(
                                translations,
                              );
                            } catch (e) {
                              // If fetching/parsing fails, keep existing translations.
                            }
                          }
                          await LanguageManager.instance.setLocale(
                            parts[0],
                            parts[1],
                          );
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
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

  Widget _buildLanguageItem(
    BuildContext context,
    WidgetRef ref,
    String language,
    String code,
    VoidCallback onSelect,
  ) {
    final isSelected =
        LanguageManager.instance.currentLocale.countryCode == code;

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
            Icon(CupertinoIcons.check_mark, color: context.textColor, size: 16),
          ],
        ],
      ),
    );
  }
}
