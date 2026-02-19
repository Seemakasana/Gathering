import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userIdKey = 'user_id';
  static const String emailKey = 'user_email';
  static const String nameKey = 'user_name';
  static const String photoUrlKey = 'photo_url';
  static const String interestKey = 'interest';
  static const String cityKey = 'city';
  static const String isLoggedInKey = 'is_logged_in';

  /// Save user data
  static Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
    String photoUrl = '',
    String interest = '',
    String city = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(userIdKey, userId);
    await prefs.setString(emailKey, email);
    await prefs.setString(nameKey, name);
    await prefs.setString(photoUrlKey, photoUrl);
    await prefs.setString(interestKey, interest);
    await prefs.setString(cityKey, city);
    await prefs.setBool(isLoggedInKey, true);
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;
    if (!isLoggedIn) return null;

    final userId = prefs.getString(userIdKey);
    final email = prefs.getString(emailKey);
    final name = prefs.getString(nameKey);

    if (userId == null || email == null || name == null) {
      return null;
    }

    return {
      'id': userId,
      'email': email,
      'name': name,
      'photoUrl': prefs.getString(photoUrlKey) ?? '',
      'interest': prefs.getString(interestKey) ?? '',
      'city': prefs.getString(cityKey) ?? '',
    };
  }

  /// Check login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  /// Clear user data (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(userIdKey);
    await prefs.remove(emailKey);
    await prefs.remove(nameKey);
    await prefs.remove(photoUrlKey);
    await prefs.remove(interestKey);
    await prefs.remove(cityKey);
    await prefs.remove(isLoggedInKey);
  }

  /// Update name
  static Future<void> updateUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, name);
  }

  /// Update email
  static Future<void> updateUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }
}
