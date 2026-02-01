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
    'de_DE': 'https://beszel.flexipgroup.com/assets/de-BuT7B2oz.js',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([LanguageManager.instance, ThemeManager.instance]),
      builder: (context, _) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showLanguageSelector(context),
          child: Icon(
            Icons.translate,
            color: context.textColor,
            size: 20,
          ),
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context) {
    // Capture theme colors from current context BEFORE opening dialog
    final backgroundColor = context.backgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final borderColor = context.borderColor;

    showCupertinoModalPopup(
      context: context,
      builder: (dialogContext) => _LanguageSelectorDialog(
        localeAssetUrls: _localeAssetUrls,
        onClose: () => Navigator.pop(dialogContext),
        backgroundColor: backgroundColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
        borderColor: borderColor,
      ),
    );
  }
}

class _LanguageSelectorDialog extends StatefulWidget {
  final Map<String, String> localeAssetUrls;
  final VoidCallback onClose;
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color borderColor;

  const _LanguageSelectorDialog({
    required this.localeAssetUrls,
    required this.onClose,
    required this.backgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  @override
  State<_LanguageSelectorDialog> createState() => _LanguageSelectorDialogState();
}

class _LanguageSelectorDialogState extends State<_LanguageSelectorDialog> {
  late Color _backgroundColor;
  late Color _textColor;
  late Color _secondaryTextColor;
  late Color _borderColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.backgroundColor;
    _textColor = widget.textColor;
    _secondaryTextColor = widget.secondaryTextColor;
    _borderColor = widget.borderColor;
    ThemeManager.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        // Update colors based on new theme using context extensions
        _backgroundColor = context.backgroundColor;
        _textColor = context.textColor;
        _secondaryTextColor = context.secondaryTextColor;
        _borderColor = context.borderColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Select Language',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(height: 1, color: _borderColor),
            // Language list
            Flexible(
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Consumer(
                    builder: (consumerContext, ref, __) {
                      final manifestAsync = ref.watch(languageAssetsManifestProvider);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: LanguageManager.supportedLocales.entries.map((entry) {
                          final parts = entry.key.split('_');
                          final fullCode = entry.key;
                          return _buildLanguageItem(
                            ref,
                            entry.value['nativeName']!,
                            parts[1],
                            () async {
                              String? assetUrl;
                              final manifest = manifestAsync.asData?.value ?? {};
                              assetUrl = manifest[fullCode] ?? widget.localeAssetUrls[fullCode];
                              if (assetUrl != null) {
                                try {
                                  final translations = await ref.read(
                                    translationsProvider(assetUrl).future,
                                  );
                                  LanguageManager.instance.setTranslations(translations);
                                } catch (e) {
                                  // If fetching/parsing fails, keep existing translations.
                                }
                              }
                              await LanguageManager.instance.setLocale(parts[0], parts[1]);
                              widget.onClose();
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: _borderColor),
            // Cancel button
            CupertinoButton(
              onPressed: widget.onClose,
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    WidgetRef ref,
    String language,
    String code,
    VoidCallback onSelect,
  ) {
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
              color: _secondaryTextColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            language,
            style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            Icon(CupertinoIcons.check_mark, color: _textColor, size: 16),
          ],
        ],
      ),
    );
  }
}
