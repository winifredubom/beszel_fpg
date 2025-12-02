import 'package:flutter/cupertino.dart';
import '../storage/storage_service.dart';
import '../config/app_config.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._();
  static ThemeManager get instance => _instance;
  
  ThemeManager._() {
    _isDarkMode = AppConfig.isDarkModeDefault;
  }

  bool _isDarkMode = AppConfig.isDarkModeDefault;
  
  bool get isDarkMode => _isDarkMode;
  
  /// Initialize theme from stored preferences
  Future<void> init() async {
    final storedTheme = StorageService.getBool(AppConfig.themeKey);
    if (storedTheme != null) {
      _isDarkMode = storedTheme;
    }
  }
  
  /// Toggle between dark and light mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setBool(AppConfig.themeKey, _isDarkMode);
    notifyListeners();
  }
  
  /// Set specific theme mode
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) return;
    
    _isDarkMode = isDark;
    await StorageService.setBool(AppConfig.themeKey, _isDarkMode);
    notifyListeners();
  }
  
  /// Get current theme mode for CupertinoApp
  Brightness get brightness => _isDarkMode ? Brightness.dark : Brightness.light;
}
