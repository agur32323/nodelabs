import 'package:shared_preferences/shared_preferences.dart';

class ProfilePhotoStorage {
  static const String _photoKey = "user_profile_photo";

  static Future<void> savePhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey, path);
  }

  static Future<String?> getPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoKey);
  }

  static Future<void> clearPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_photoKey);
  }
}
