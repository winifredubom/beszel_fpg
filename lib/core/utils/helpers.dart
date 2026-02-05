import 'package:flutter/material.dart';

class Validators {
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return 'Please enter a valid URL';
    }
    
    if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
      return 'URL must start with http:// or https://';
    }
    
    return null;
  }
  
  static String? validateServerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Server name is required';
    }
    
    if (value.length < 2) {
      return 'Server name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Server name must be less than 50 characters';
    }
    
    return null;
  }
  
  static String? validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Port is optional
    }
    
    final port = int.tryParse(value);
    if (port == null) {
      return 'Port must be a number';
    }
    
    if (port < 1 || port > 65535) {
      return 'Port must be between 1 and 65535';
    }
    
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

class AppHelpers {
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
  
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }
  
  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
  
  static String formatUptime(Duration uptime) {
    if (uptime.inDays > 0) {
      return '${uptime.inDays} days';
    } else if (uptime.inHours > 0) {
      return '${uptime.inHours} hours';
    } else if (uptime.inMinutes > 0) {
      return '${uptime.inMinutes} minutes';
    } else {
      return '${uptime.inSeconds} seconds';
    }
  }
  
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
      case 'up':
        return Colors.green;
      case 'offline':
      case 'down':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  static String getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'online':
      case 'up':
        return 'Up';
      case 'offline':
      case 'down':
        return 'Down';
      case 'warning':
        return 'Warning';
      default:
        return status;
    }
  }
  
  static String getStatusText(bool isOnline) {
    return isOnline ? 'Up' : 'Down';
  }
}
