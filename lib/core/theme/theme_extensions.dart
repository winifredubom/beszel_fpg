import 'package:flutter/cupertino.dart';
import 'theme_manager.dart';
import 'app_theme.dart';

/// Extension to easily access theme-dependent colors throughout the app
extension ThemeContext on BuildContext {
  /// Get current theme manager instance
  ThemeManager get themeManager => ThemeManager.instance;
  
  /// Check if current theme is dark mode
  bool get isDarkMode => ThemeManager.instance.isDarkMode;
  
  /// Get background color based on current theme
  Color get backgroundColor => isDarkMode 
      ? AppColors.backgroundLight
      : AppColors.backgroundDark;
  
  /// Get surface color based on current theme
  Color get surfaceColor => isDarkMode 
      ? AppColors. surfaceLight
      : AppColors.surfaceDark;
  
  /// Get primary text color based on current theme
  Color get textColor => isDarkMode 
      ? AppColors.textPrimary 
      : AppColors.textPrimaryDark;
       Color get subtextColor => isDarkMode 
      ? AppColors.textPrimaryDark 
      : AppColors.textPrimary;
  
  Color get buttonColor => isDarkMode 
      ? AppColors.textPrimary 
      : AppColors.textPrimaryDark;
  /// Get secondary text color based on current theme
  Color get secondaryTextColor => isDarkMode 
      ? AppColors.textSecondaryDark 
      : AppColors.textSecondary;
  
  /// Get border color based on current theme
  Color get borderColor => isDarkMode 
      ? AppColors.borderDark 
      : AppColors.borderLight;
  
  /// Get current Cupertino theme data
  CupertinoThemeData get cupertinoTheme => isDarkMode 
      ? AppTheme.darkCupertinoTheme 
      : AppTheme.lightCupertinoTheme;
}
