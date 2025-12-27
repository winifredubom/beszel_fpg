import 'package:hive/hive.dart';
import '../exceptions/app_exceptions.dart';

class StorageService {
  static const String _boxName = 'app_storage';
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static Box get _instance {
    if (_box == null) {
      throw StorageException.readError();
    }
    return _box!;
  }

  // String operations
  static Future<void> setString(String key, String value) async {
    try {
      await _instance.put(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static String? getString(String key) {
    try {
      return _instance.get(key) as String?;
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Bool operations
  static Future<void> setBool(String key, bool value) async {
    try {
      await _instance.put(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static bool? getBool(String key) {
    try {
      return _instance.get(key) as bool?;
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Int operations
  static Future<void> setInt(String key, int value) async {
    try {
      await _instance.put(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static int? getInt(String key) {
    try {
      return _instance.get(key) as int?;
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Double operations
  static Future<void> setDouble(String key, double value) async {
    try {
      await _instance.put(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static double? getDouble(String key) {
    try {
      return _instance.get(key) as double?;
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // List<String> operations
  static Future<void> setStringList(String key, List<String> value) async {
    try {
      await _instance.put(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static List<String>? getStringList(String key) {
    try {
      return (_instance.get(key) as List?)?.cast<String>();
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Remove operations
  static Future<void> remove(String key) async {
    try {
      await _instance.delete(key);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> clear() async {
    try {
      await _instance.clear();
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
      return _instance.keys.cast<String>().toSet();
    } catch (e) {
      throw StorageException.readError();
    }
  }
}