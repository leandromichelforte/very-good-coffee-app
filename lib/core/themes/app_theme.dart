import 'package:flutter/material.dart';

/// [AppTheme] provides application-wide theme configurations for the app.
///
/// Use [AppTheme.light] for the default Material 3 light theme.
abstract interface class AppTheme {
  /// The default light theme for the app, using Material 3 and a blue accent seed color.
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),
    );
  }
}
