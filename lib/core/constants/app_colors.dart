import 'package:flutter/material.dart';

/// Application color constants
/// All colors used in the app should be defined here
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color accent = Color(0xFFFF4081);

  // Background Colors
  static const Color backgroundDark1 = Color(0xFF1a1a2e);
  static const Color backgroundDark2 = Color(0xFF16213e);
  static const Color backgroundDark3 = Color(0xFF0f3460);

  // Gradient Backgrounds
  static const List<Color> backgroundGradient = [
    backgroundDark1,
    backgroundDark2,
    backgroundDark3,
  ];

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);

  // Folder Icon Colors
  static const Color folderBlue = Color(0xFF2196F3);
  static const Color folderGreen = Color(0xFF4CAF50);
  static const Color folderPurple = Color(0xFF9C27B0);
  static const Color folderGrey = Color(0xFF607D8B);
  static const Color folderOrange = Color(0xFFFF5722);
  static const Color folderYellow = Color(0xFFFFEB3B);
  static const Color folderBrown = Color(0xFF795548);
  static const Color folderIndigo = Color(0xFF3F51B5);
  static const Color folderDarkGrey = Color(0xFF757575);

  // Social Media Colors
  static const Color linkedIn = Color(0xFF0077B5);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color github = Color(0xFF333333);

  // Game Theme Colors
  static const List<Color> snakeGameGradient = [
    Color(0xFF0f4c3a),
    Color(0xFF1a5f4a),
    Color(0xFF2d7a5a),
  ];

  static const List<Color> tetrisGameGradient = [
    Color(0xFF2d1b69),
    Color(0xFF11998e),
    Color(0xFF38ef7d),
  ];

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // UI Element Colors
  static const Color cardBackground = Color(0xFF2a2a3e);
  static const Color divider = Color(0xFF404040);
  static const Color shadow = Color(0x33000000);

  // Opacity variations - uses withValues internally (modern API)
  /// Helper to apply opacity to a color
  /// Uses withValues internally to avoid deprecated withOpacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
