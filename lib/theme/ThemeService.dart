import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  final _csKey = 'colorScheme';

  /// Load isDArkMode from local storage and if it's empty, returns false (that means default theme is light)
  bool _loadThemeFromBox() => _box.read<bool>(_key) ?? false;

  /// Get isDarkMode info from local storage and return ThemeMode
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  /// Save isDarkMode to local storage
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// Switch theme and save to local storage
  void switchTheme() {
    _saveThemeToBox(!_loadThemeFromBox());
    print(theme);
    print("changing theme mode " + _loadThemeFromBox().toString());
    Get.changeThemeMode(
        !_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
  }

  Map<dynamic, dynamic> _loadColorSchemeFromBox() =>
      _box.read<Map<dynamic, dynamic>>(_csKey) ?? {};

  Map<dynamic, dynamic> get colorScheme => _loadColorSchemeFromBox();

  _saveColorSchemeToBox(Map<dynamic, dynamic> colorScheme) =>
      _box.write(_csKey, colorScheme);

  void saveTheme(bool isDark) {
    _saveThemeToBox(isDark);
  }

  void saveColorScheme(Map<dynamic, dynamic> colorScheme) {
    _saveColorSchemeToBox(colorScheme);
  }

  void deleteColorScheme() {
    _box.remove(_csKey);
  }

  void deleteTheme() {
    _box.remove(_key);
  }
}
