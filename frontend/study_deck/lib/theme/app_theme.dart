import 'package:flutter/material.dart';

enum MyThemeMode { light, dark, purple }

abstract class AppTheme {
  static ThemeData get lightMode => ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF192BC2),
    scaffoldBackgroundColor: Color(0xFFF8F8FF),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF192BC2),
      secondary: Color(0xFF449DD1),
      surface: Color(0xFF78C0E0),
    ),
    cardColor: Color(0xFFF8F8FF),
  );

  static ThemeData get darkMode => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF0E1C26),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF2A454B),
      tertiary: Color(0xFF1C3139),
      secondary: Color(0xFFFCFF4B),
    ),
    cardColor: Color(0xFF2A454B),
    textTheme: TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
  );

  static ThemeData get purpleMode => ThemeData(
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.black),
    ),
    scaffoldBackgroundColor: Color.fromARGB(255, 250, 233, 252),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF9D4EDD),
      secondary: Color(0xFFC77DFF),
      tertiary: Color(0xFFF8F8FF),
      onPrimary: Color(0xFFE0AAFF),
      onSurface: Color(0xFFE0AAFF),
    ),
    cardColor: Color(0xFFF8F8FF),
  );

  static ThemeData getTheme(MyThemeMode mode) {
    switch (mode) {
      case MyThemeMode.light:
        return lightMode;
      case MyThemeMode.dark:
        return darkMode;
      case MyThemeMode.purple:
        return purpleMode;
    }
  }

  static String getLabel(MyThemeMode mode) {
    switch (mode) {
      case MyThemeMode.light:
        return "Helles Design";
      case MyThemeMode.dark:
        return "Dunkles Design";
      case MyThemeMode.purple:
        return "Lila Design";
    }
  }

  static IconData getIcon(MyThemeMode mode) {
    switch (mode) {
      case MyThemeMode.light:
        return Icons.light_mode;
      case MyThemeMode.dark:
        return Icons.dark_mode;
      case MyThemeMode.purple:
        return Icons.invert_colors;
    }
  }

  static LinearGradient getAppBarGradient(MyThemeMode mode) {
    switch (mode) {
      case MyThemeMode.light:
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFF192bc2), Color(0xFF150578)],
        );
      case MyThemeMode.dark:
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFF2A454B), Color.fromARGB(255, 6, 12, 17)],
        );
      case MyThemeMode.purple:
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFFC77DFF), Color(0xFF7B2CBF)],
        );
    }
  }
}
