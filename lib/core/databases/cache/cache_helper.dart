import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences _prefs;

  CacheHelper(this._prefs);

  /// Save any supported value
  Future<bool> save({required String key, required Object value}) async {
    if (value is String) return _prefs.setString(key, value);
    if (value is bool) return _prefs.setBool(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is double) return _prefs.setDouble(key, value);

    throw UnsupportedError('Type not supported');
  }

  /// Get a value of type T
  T? get<T>(String key) {
    return _prefs.get(key) as T?;
  }

  /// Remove a value
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Check if key exists
  bool contains(String key) {
    return _prefs.containsKey(key);
  }

  /// Clear all cache
  Future<bool> clear() async {
    return _prefs.clear();
  }
}
