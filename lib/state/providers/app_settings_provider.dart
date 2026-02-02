import 'package:flutter/material.dart';

import '../../core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  AppSettingsProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(AppKeys.themeMode) ?? 'light';
    _themeMode = (v == 'dark') ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;

    final p = await SharedPreferences.getInstance();
    await p.setString(AppKeys.themeMode, _themeMode == ThemeMode.dark ? 'dark' : 'light');

    notifyListeners();
  }

  // Optional: set theme directly
  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final p = await SharedPreferences.getInstance();
    await p.setString(AppKeys.themeMode, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
