import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        primary: Colors.teal,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
    );
  }
}
