class AppConfig {
  static const String appName = 'Beszel Monitor';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:8090'; // Default Beszel port
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  
  // Refresh intervals
  static const Duration defaultRefreshInterval = Duration(seconds: 5);
  static const Duration chartRefreshInterval = Duration(seconds: 10);
  
  // Chart configuration
  static const int maxDataPoints = 100;
  static const Duration dataRetentionPeriod = Duration(hours: 24);
  
  // Theme configuration
  static const bool isDarkModeDefault = true;
  
  // Storage keys
  static const String apiUrlKey = 'api_url';
  static const String authTokenKey = 'auth_token';
  static const String themeKey = 'theme_mode';
  static const String refreshIntervalKey = 'refresh_interval';
}
