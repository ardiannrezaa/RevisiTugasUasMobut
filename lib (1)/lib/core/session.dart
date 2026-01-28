import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _keyIsLogin = "is_login";
  static const _keyUserId = "user_id";
  static const _keyName = "name";
  static const _keyEmail = "email";

  static Future<void> saveLogin({
    required String userId,
    required String name,
    required String email,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_keyIsLogin, true);
    await sp.setString(_keyUserId, userId);
    await sp.setString(_keyName, name);
    await sp.setString(_keyEmail, email);
  }

  static Future<bool> isLogin() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_keyIsLogin) ?? false;
  }

  static Future<Map<String, String>> getUser() async {
    final sp = await SharedPreferences.getInstance();
    return {
      "user_id": sp.getString(_keyUserId) ?? "",
      "name": sp.getString(_keyName) ?? "",
      "email": sp.getString(_keyEmail) ?? "",
    };
  }

  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
