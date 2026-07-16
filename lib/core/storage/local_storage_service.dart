import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_service.dart';

class LocalStorageService implements StorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String _themeKey = 'app_theme_mode';
  static const String _localeKey = 'app_locale';

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<void> remove(String key) async => _prefs.remove(key);

  @override
  Future<void> clear() async => _prefs.clear();

  @override
  Future<ThemeMode?> getThemeMode() async {
    final String? value = _prefs.getString(_themeKey);
    if (value == null) {
      return null;
    }
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  @override
  Future<String?> getLocale() async => _prefs.getString(_localeKey);

  @override
  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
  }
}
