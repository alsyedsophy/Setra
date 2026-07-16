import 'package:flutter/material.dart';

abstract class StorageService {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);

  Future<void> remove(String key);
  Future<void> clear();

  Future<ThemeMode?> getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);

  Future<String?> getLocale();
  Future<void> setLocale(String languageCode);
}
