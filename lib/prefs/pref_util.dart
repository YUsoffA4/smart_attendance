import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static Future<SharedPreferences> getSharePref() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> clearData() async {
    return (await getSharePref()).clear();
  }

  static Future<bool> setString(String key, String data) async {
    return (await getSharePref()).setString(key, data);
  }

  static Future<String> getString(String key) async {
    return (await getSharePref()).getString(key);
  }

  static Future<bool> setStringList(String key, List<String> data) async {
    return (await getSharePref()).setStringList(key, data);
  }

  static Future<List<String>> getStringList(String key) async {
    return (await getSharePref()).getStringList(key);
  }

  static Future<bool> setDouble(String key, double data) async {
    return (await getSharePref()).setDouble(key, data);
  }

  static Future<double> getDouble(String key) async {
    return (await getSharePref()).getDouble(key);
  }

  static Future<bool> setBool(String key, bool data) async {
    return (await getSharePref()).setBool(key, data);
  }

  static Future<bool> getBool(String key) async {
    var result = (await getSharePref()).getBool(key);
    if (result != null)
      return result;
    else
      return false;
  }
}
