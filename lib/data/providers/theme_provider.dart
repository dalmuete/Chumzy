import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isUserToggled = false; 

  ThemeMode get themeMode => _themeMode;

  bool get isUserToggled => _isUserToggled;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _isUserToggled = mode != ThemeMode.system;
    notifyListeners();
  }
  Future<void> toggleThemeMode(bool isDark) async {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void updateSystemTheme(ThemeMode mode) {
    if (!_isUserToggled) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void resetToSystemMode() {
    _themeMode = ThemeMode.system;
    _isUserToggled = false;
    notifyListeners();
  }
}
