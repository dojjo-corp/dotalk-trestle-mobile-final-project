import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // ignore: unused_field, prefer_final_fields
  ThemeData _currentTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey[50]!, background: Colors.blueGrey[50]),
    useMaterial3: true,
  );
  ThemeData get currentTheme => _currentTheme;

  bool _isDark = false;
  bool get isDark => _isDark;

  void changeTheme(bool toDark) {
    _isDark = toDark;
    _isDark
        ? _currentTheme = ThemeData(colorScheme: const ColorScheme.dark())
        : _currentTheme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueGrey[50]!,
                background: Colors.blueGrey[50]),
            useMaterial3: true,
          );
  }
}
