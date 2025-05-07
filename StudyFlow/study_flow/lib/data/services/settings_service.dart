import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _selectedGroupKey = 'selected_group';

  static Future<String?> getSelectedGroupCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedGroupKey);
  }

  static Future<void> setSelectedGroupCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedGroupKey, code);
  }
}