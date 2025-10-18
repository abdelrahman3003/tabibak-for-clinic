import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final SharedPreferences _prefs;
  SharedPrefHelper(this._prefs);

  final Logger logger = Logger(printer: PrettyPrinter());

  static AndroidOptions _getAndroidOptions() {
    return const AndroidOptions(encryptedSharedPreferences: true);
  }

  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  /// Saves a [value] with a [key] in shared preferences.
  Future<void> setData({required String key, required dynamic value}) async {
    logger.i('SharedPrefService Setting data with key: $key and value: $value');
    switch (value) {
      case String _:
        await _prefs.setString(key, value);
        break;
      case int _:
        await _prefs.setInt(key, value);
        break;
      case double _:
        await _prefs.setDouble(key, value);
        break;
      case bool _:
        await _prefs.setBool(key, value);
        break;
      case List<String> _:
        await _prefs.setStringList(key, value);
        break;
      default:
        throw Exception('Unsupported type');
    }
  }

  /// Removes a value associated with the [key] from shared preferences.
  Future<void> removeData(String key) async {
    logger.i('SharedPrefService Removing data with key: $key');
    await _prefs.remove(key);
  }

  /// Get a string value associated with the [key] from shared preferences.
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Get a boolean value associated with the [key] from shared preferences.
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Get a double value associated with the [key] from shared preferences.
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Get a list of strings associated with the [key] from shared preferences.
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Get an integer value associated with the [key] from shared preferences.
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<String?> getSecuredString(String key) async {
    return await storage.read(key: key);
  }

  Future<void> setSecureString({
    required String key,
    required String value,
  }) async {
    logger.i(
      'SharedPrefService Setting secure data with key: $key and value: $value',
    );
    await storage.write(key: key, value: value);
  }
}

class SharedPrefKeys {
  static const String userToken = 'userToken';
  static const String step = 'step';
  static const String lang = "lang";
  static const String isDark = "isDark";
  static const String searchDoctors = "'searchDoctors'";
}
