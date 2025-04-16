import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _key = 'is_dark_mode';

  ThemeProvider(this.prefs) {
    _isDarkMode = prefs.getBool(_key) ?? false;
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await prefs.setBool(_key, _isDarkMode);
    notifyListeners();
  }
}
