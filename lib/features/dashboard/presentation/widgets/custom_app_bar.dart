import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_manager.dart';
import 'language_selector.dart';
import 'theme_toggle_button.dart';
import 'profile_popup.dart';

class CustomAppBar extends StatelessWidget {
  final bool canGoBack;
  final VoidCallback? onBackPressed;
  final Widget? leadingIcon;
  final List<Widget>? additionalActions;
  final bool isFloating;
  final double titleFontSize;

  const CustomAppBar({
    super.key,
    this.canGoBack = false,
    this.onBackPressed,
    this.leadingIcon,
    this.additionalActions,
    this.isFloating = true,
    this.titleFontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, _) {
        final isDarkMode = ThemeManager.instance.isDarkMode;
        final appBarContent = Row(
          children: [
        if (leadingIcon != null)
          leadingIcon!,
        GestureDetector(
          onTap: canGoBack ? (onBackPressed ?? () {context.go('/');}) : null,
          child: Text(
            'Beszel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
              color: context.textColor,
            ),
          ),
        ),
        const Spacer(),
        const ThemeToggleButton(),
        const SizedBox(width: 5),
          const LanguageSelector(),
          const SizedBox(width: 5),
        
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Navigate to settings
          },
          child: Icon(
            CupertinoIcons.gear,
            color: context.textColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 5),
        const ProfilePopup(),
        const SizedBox(width: 5),
      ],
    );

    
    if (!isFloating) {
      return SliverAppBar(
        pinned: true,
        backgroundColor: isDarkMode 
            ? context.surfaceColor.withOpacity(0.8)
            : context.surfaceColor,
        elevation: 0,
        expandedHeight: 0,
        title: appBarContent,
      );
    }

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? context.surfaceColor.withOpacity(0.8)
              : context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isDarkMode ? 20 : 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? context.borderColor.withOpacity(0.2)
                : context.borderColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: appBarContent,
      ),
    );
  }
    );
  }
}