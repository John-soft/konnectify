import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPersistence {
  static const String _keyLoggedIn = 'loggedIn';
  static const String _keyUserId = 'userId';

  static Future<void> saveLoginData(User user) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(_keyLoggedIn, true);
    preferences.setString(_keyUserId, user.uid);
  }

  static Future<String?> getUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyUserId);
  }

  static Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_keyLoggedIn) ?? false;
  }

  static Future<void> clearLoginData() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
