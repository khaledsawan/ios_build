import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static CacheHelper? _instance;
  static late SharedPreferences _sharedPreferences;
  static bool _isInitialized = false;

  CacheHelper._();

  static CacheHelper get instance {
    _instance ??= CacheHelper._();
    return _instance!;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    _sharedPreferences = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  String? getDataString({required String key}) {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    return _sharedPreferences.getString(key);
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    if (value == null) {
      // احذف المفتاح إذا القيمة null
      return await _sharedPreferences.remove(key);
    }

    if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    }

    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await _sharedPreferences.setInt(key, value);
    }

    if (value is double) {
      return await _sharedPreferences.setDouble(key, value);
    }

    // أي نوع آخر (مثل Map, List …)
    return await _sharedPreferences.setString(key, value.toString());
  }

  dynamic getData({required String key}) {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    return _sharedPreferences.get(key);
  }

  Future<bool> removeData({required String key}) async {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    return _sharedPreferences.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    return _sharedPreferences.containsKey(key);
  }

  Future<bool> clearData() async {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    return await _sharedPreferences.clear();
  }

  Future<dynamic> put({required String key, required dynamic value}) async {
    if (!_isInitialized) throw Exception('CacheHelper not initialized');
    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } else {
      return await _sharedPreferences.setInt(key, value);
    }
  }
}
