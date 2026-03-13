import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_deck/theme/app_theme.dart';

const _themeKey = "theme";

class ThemeProvider extends ChangeNotifier {
  MyThemeMode _themeMode = MyThemeMode.light;

  MyThemeMode get themeMode => _themeMode;

  void setThemeMode(MyThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString(_themeKey);

    if (themeMode == "light") {
      _themeMode = MyThemeMode.light;
    } else if (themeMode == "dark") {
      _themeMode = MyThemeMode.dark;
    } else if (themeMode == "purple") {
      _themeMode = MyThemeMode.purple;
    } else {
      _themeMode = MyThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> setTheme(MyThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.toString());
    _themeMode = themeMode;
    notifyListeners();
  }
}
