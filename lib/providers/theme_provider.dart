import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      final isSystemDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
      _themeMode = isSystemDark ? ThemeMode.light : ThemeMode.dark;
    } else {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
    notifyListeners();
  }
}
