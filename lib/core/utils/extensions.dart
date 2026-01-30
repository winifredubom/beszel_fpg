import '../language/language_manager.dart';
extension StringExtensions on String {
  /// Capitalize first letter of string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Translate this string using the loaded language dictionary
  String tr() {
    return LanguageManager.instance.translate(this);
  }
  
  /// Check if string is a valid URL
  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }
  
  /// Check if string is a valid IP address
  bool get isValidIpAddress {
    final RegExp ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegex.hasMatch(this);
  }
}

extension DurationExtensions on Duration {
  /// Format duration to human readable string
  String get toHumanReadable {
    if (inDays > 0) {
      return '${inDays}d ${inHours.remainder(24)}h';
    } else if (inHours > 0) {
      return '${inHours}h ${inMinutes.remainder(60)}m';
    } else if (inMinutes > 0) {
      return '${inMinutes}m ${inSeconds.remainder(60)}s';
    } else {
      return '${inSeconds}s';
    }
  }
}

extension DoubleExtensions on double {
  /// Format bytes to human readable string
  String get toBytesString {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = this;
    var suffixIndex = 0;
    
    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }
    
    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${suffixes[suffixIndex]}';
  }
  
  /// Format percentage with % symbol
  String get toPercentageString {
    return '${toStringAsFixed(1)}%';
  }
  
  /// Format speed to human readable string (MB/s)
  String get toSpeedString {
    if (this < 1) {
      return '${(this * 1024).toStringAsFixed(1)} KB/s';
    }
    return '${toStringAsFixed(1)} MB/s';
  }
}

extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Format to relative time string
  String get toRelativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Format to time string (HH:mm)
  String get toTimeString {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
