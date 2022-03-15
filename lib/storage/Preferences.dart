import 'package:hive/hive.dart';

class Preferences {
  static const _preferencesBox = '_preferencesBox';
  static const _tokenKey = '_tokenKey';
  static const _themeKey = '_themeKey';

  final Box<dynamic> _box;
  Preferences._(this._box);

  static Future<Preferences> getInstance() async {
    final box = await Hive.openBox<dynamic>(_preferencesBox);
    return Preferences._(box);
  }

  Future<void> setToken(String token) => _setValue(_tokenKey, token);

  Future<void> setTheme(Map<dynamic, dynamic> theme) =>
      _setValue(_themeKey, theme);

  String getToken() => _getValue<String>('_tokenKey', '');
  Map<dynamic, dynamic> getTheme() =>
      _getValue<Map<dynamic, dynamic>>('_themeKey', {});

  T _getValue<T>(dynamic key, T defaultValue) =>
      _box.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);

  Future<void> deleteToken() async {
    await _box.clear();
  }
}
