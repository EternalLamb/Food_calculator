import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        primary: Colors.green[800],
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
    );
  }
}
