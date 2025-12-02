import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager extends ChangeNotifier {
  static final LanguageManager _instance = LanguageManager._internal();
  static LanguageManager get instance => _instance;
  
  final String _prefsKey = 'selected_locale';
  SharedPreferences? _prefs;
  
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  
  LanguageManager._internal();
  
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLocale = _prefs?.getString(_prefsKey);
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      if (parts.length == 2) {
        _currentLocale = Locale(parts[0], parts[1]);
      }
    }
    notifyListeners();
  }
  
  Future<void> setLocale(String languageCode, String countryCode) async {
    _currentLocale = Locale(languageCode, countryCode);
    await _prefs?.setString(_prefsKey, '${languageCode}_${countryCode}');
    notifyListeners();
  }
  
  static final Map<String, Map<String, String>> supportedLocales = {
    'ar_PS': {'name': 'العربية', 'nativeName': 'العربية'},
    'bg_BG': {'name': 'Bulgarian', 'nativeName': 'Български'},
    'cs_CZ': {'name': 'Czech', 'nativeName': 'Čeština'},
    'da_DK': {'name': 'Danish', 'nativeName': 'Dansk'},
    'de_DE': {'name': 'German', 'nativeName': 'Deutsch'},
    'en_US': {'name': 'English', 'nativeName': 'English'},
    'es_MX': {'name': 'Spanish', 'nativeName': 'Español'},
    'fa_IR': {'name': 'Persian', 'nativeName': 'فارسی'},
    'fr_FR': {'name': 'French', 'nativeName': 'Français'},
    'hr_HR': {'name': 'Croatian', 'nativeName': 'Hrvatski'},
    'hu_HU': {'name': 'Hungarian', 'nativeName': 'Magyar'},
    'it_IT': {'name': 'Italian', 'nativeName': 'Italiano'},
    'ja_JP': {'name': 'Japanese', 'nativeName': '日本語'},
    'ko_KR': {'name': 'Korean', 'nativeName': '한국어'},
    'nl_NL': {'name': 'Dutch', 'nativeName': 'Nederlands'},
    'no_NO': {'name': 'Norwegian', 'nativeName': 'Norsk'},
    'pl_PL': {'name': 'Polish', 'nativeName': 'Polski'},
    'pt_BR': {'name': 'Portuguese', 'nativeName': 'Português'},
    'tr_TR': {'name': 'Turkish', 'nativeName': 'Türkçe'},
    'ru_RU': {'name': 'Russian', 'nativeName': 'Русский'},
    'sl_SI': {'name': 'Slovenian', 'nativeName': 'Slovenščina'},
    'sv_SE': {'name': 'Swedish', 'nativeName': 'Svenska'},
    'uk_UA': {'name': 'Ukrainian', 'nativeName': 'Українська'},
    'vi_VN': {'name': 'Vietnamese', 'nativeName': 'Tiếng Việt'},
    'zh_CN': {'name': 'Chinese (Simplified)', 'nativeName': '简体中文'},
    'zh_TW': {'name': 'Chinese (Traditional)', 'nativeName': '繁體中文'},
  };
}