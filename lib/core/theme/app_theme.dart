import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color primaryColorDark = Color(0xFF0056D6);
  static const Color primaryColorLight = Color(0xFF409CFF);
  
  // Secondary colors
  static const Color secondaryColor = Color(0xFF8E8E93);
  static const Color secondaryColorDark = Color(0xFF636366);
  static const Color secondaryColorLight = Color(0xFFAEAEB2);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF2F2F7);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  
  // Text colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  
  // Status colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);
  
  // Chart colors
  static const Color cpuColor = Color(0xFF007AFF);
  static const Color memoryColor = Color(0xFF34C759);
  static const Color diskColor = Color(0xFFAF52DE);
  static const Color networkColor = Color(0xFFFF9500);
  static const Color dockerColor = Color(0xFFFF3B30);
  
  // Border colors
  static const Color borderLight = Color(0xFFC6C6C8);
  static const Color borderDark = Color(0xFF38383A);
}

class AppTheme {
  static CupertinoThemeData lightCupertinoTheme = const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    barBackgroundColor: AppColors.surfaceLight,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.textPrimary,
      textStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontFamily: '.SF Pro Text',
      ),
      navTitleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Text',
      ),
      navLargeTitleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        fontFamily: '.SF Pro Display',
      ),
      actionTextStyle: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 17,
        fontFamily: '.SF Pro Text',
      ),
      tabLabelTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 10,
        fontFamily: '.SF Pro Text',
      ),
    ),
  );

  static CupertinoThemeData darkCupertinoTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    barBackgroundColor: AppColors.surfaceDark,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.textPrimaryDark,
      textStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 16,
        fontFamily: '.SF Pro Text',
      ),
      navTitleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Text',
      ),
      navLargeTitleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        fontFamily: '.SF Pro Display',
      ),
      actionTextStyle: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 17,
        fontFamily: '.SF Pro Text',
      ),
      tabLabelTextStyle: TextStyle(
        color: AppColors.textSecondaryDark,
        fontSize: 10,
        fontFamily: '.SF Pro Text',
      ),
    ),
  );

  // Backward compatibility
  static CupertinoThemeData cupertinoTheme = darkCupertinoTheme;

  // Keep Material themes for compatibility with some widgets
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
