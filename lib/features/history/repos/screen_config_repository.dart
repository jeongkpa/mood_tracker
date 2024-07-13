import 'package:shared_preferences/shared_preferences.dart';

class ScreenConfigRepository {
  static const String _dark = "dark";

  final SharedPreferences _preferences;

  ScreenConfigRepository(this._preferences);

  Future<void> setDark(bool value) async {
    _preferences.setBool(_dark, value);
  }

  bool isDark() {
    return _preferences.getBool(_dark) ?? false;
  }
}
