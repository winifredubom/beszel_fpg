class AppConstants {
  // App strings
  static const String appTitle = 'Beszel Monitor';
  static const String dashboard = 'Dashboard';
  static const String settings = 'Settings';
  static const String addServer = 'Add Server';
  
  // Error messages
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String connectionTimeout = 'Connection timeout';
  static const String noDataAvailable = 'No data available';
  
  // Success messages
  static const String serverAddedSuccessfully = 'Server added successfully';
  static const String settingsSaved = 'Settings saved successfully';
  
  // Labels
  static const String cpuUsage = 'CPU Usage';
  static const String memoryUsage = 'Memory Usage';
  static const String diskUsage = 'Disk Usage';
  static const String diskIO = 'Disk I/O';
  static const String bandwidth = 'Bandwidth';
  static const String dockerCpuUsage = 'Docker CPU Usage';
  static const String dockerMemoryUsage = 'Docker Memory Usage';
  static const String dockerNetworkIO = 'Docker Network I/O';
  static const String uptime = 'Uptime';
  static const String status = 'Status';
  static const String serverName = 'Server Name';
  static const String ipAddress = 'IP Address';
  
  // Status
  static const String online = 'Online';
  static const String offline = 'Offline';
  static const String unknown = 'Unknown';
  
  // Time periods
  static const String oneHour = '1 hour';
  static const String sixHours = '6 hours';
  static const String twelveHours = '12 hours';
  static const String twentyFourHours = '24 hours';
  
  // Units
  static const String percentageUnit = '%';
  static const String mbPerSecond = 'MB/s';
  static const String gbUnit = 'GB';
  static const String mbUnit = 'MB';
  static const String days = 'days';
  static const String hours = 'hours';
  static const String minutes = 'minutes';
}

class AppDimensions {
  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  
  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Chart dimensions
  static const double chartHeight = 200.0;
  static const double chartPadding = 16.0;
  
  // Card dimensions
  static const double cardElevation = 2.0;
  static const double cardMinHeight = 120.0;
}

class AppRoutes {
  static const String dashboard = '/';
  static const String systemsBoard = '/systems';
  static const String settings = '/settings';
  static const String addServer = '/add-server';
  static const String serverDetails = '/server-details';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
}
