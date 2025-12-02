import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/app_exceptions.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StorageException.readError();
    }
    return _prefs!;
  }
  
  // String operations
  static Future<bool> setString(String key, String value) async {
    try {
      return await _instance.setString(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  static String? getString(String key) {
    try {
      return _instance.getString(key);
    } catch (e) {
      throw StorageException.readError();
    }
  }
  
  // Bool operations
  static Future<bool> setBool(String key, bool value) async {
    try {
      return await _instance.setBool(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  static bool? getBool(String key) {
    try {
      return _instance.getBool(key);
    } catch (e) {
      throw StorageException.readError();
    }
  }
  
  // Int operations
  static Future<bool> setInt(String key, int value) async {
    try {
      return await _instance.setInt(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  static int? getInt(String key) {
    try {
      return _instance.getInt(key);
    } catch (e) {
      throw StorageException.readError();
    }
  }
  
  // Double operations
  static Future<bool> setDouble(String key, double value) async {
    try {
      return await _instance.setDouble(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  static double? getDouble(String key) {
    try {
      return _instance.getDouble(key);
    } catch (e) {
      throw StorageException.readError();
    }
  }
  
  // List operations
  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _instance.setStringList(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  static List<String>? getStringList(String key) {
    try {
      return _instance.getStringList(key);
    } catch (e) {
      throw StorageException.readError();
    }
  }
  
  // Remove operations
  static Future<bool> remove(String key) async {
    try {
      return await _instance.remove(key);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  static Future<bool> clear() async {
    try {
      return await _instance.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }
  
  // Check if key exists
  static bool containsKey(String key) {
    try {
      return _instance.containsKey(key);
    } catch (e) {
      throw StorageException.readError();
    }
  }
  
  // Get all keys
  static Set<String> getKeys() {
    try {
      return _instance.getKeys();
    } catch (e) {
      throw StorageException.readError();
    }
  }
}
