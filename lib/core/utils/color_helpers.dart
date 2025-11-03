import 'package:flutter/material.dart';

/// Helper functions for color operations
class ColorHelpers {
  ColorHelpers._(); // Private constructor

  /// Parse hex color string to Color
  /// Supports formats: #RGB, #RRGGBB, #AARRGGBB
  static Color parseHexColor(String hexColor) {
    String color = hexColor.replaceAll('#', '');

    // Handle #RGB format
    if (color.length == 3) {
      color = color.split('').map((c) => '$c$c').join();
    }

    // Add alpha if not present
    if (color.length == 6) {
      color = 'FF$color';
    }

    try {
      return Color(int.parse(color, radix: 16));
    } catch (e) {
      // Return a default color if parsing fails
      return const Color(0xFF2196F3);
    }
  }

  /// Convert Color to hex string
  static String toHexString(Color color, {bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      final rgb = color.toARGB32() & 0x00FFFFFF;
      return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
  }

  /// Get contrasting text color (black or white) based on background
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance
    final luminance = backgroundColor.computeLuminance();

    // Return white for dark backgrounds, black for light backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Lighten color by percentage (0.0 to 1.0)
  static Color lighten(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + percentage).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Darken color by percentage (0.0 to 1.0)
  static Color darken(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - percentage).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Create color with custom opacity
  /// Use this instead of deprecated withOpacity
  static Color withOpacity(Color color, double opacity) {
    assert(opacity >= 0 && opacity <= 1);
    return color.withValues(alpha: opacity);
  }

  /// Blend two colors together
  static Color blend(Color color1, Color color2, double ratio) {
    assert(ratio >= 0 && ratio <= 1);

    final r1 = ((color1.r * 255.0).round() & 0xff);
    final g1 = ((color1.g * 255.0).round() & 0xff);
    final b1 = ((color1.b * 255.0).round() & 0xff);
    final a1 = ((color1.a * 255.0).round() & 0xff);

    final r2 = ((color2.r * 255.0).round() & 0xff);
    final g2 = ((color2.g * 255.0).round() & 0xff);
    final b2 = ((color2.b * 255.0).round() & 0xff);
    final a2 = ((color2.a * 255.0).round() & 0xff);

    final r = (r1 * (1 - ratio) + r2 * ratio).round();
    final g = (g1 * (1 - ratio) + g2 * ratio).round();
    final b = (b1 * (1 - ratio) + b2 * ratio).round();
    final a = (a1 * (1 - ratio) + a2 * ratio).round();

    return Color.fromARGB(a, r, g, b);
  }

  /// Get folder icon color by name
  static Color getFolderColorByName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return const Color(0xFF2196F3);
      case 'green':
        return const Color(0xFF4CAF50);
      case 'purple':
        return const Color(0xFF9C27B0);
      case 'grey':
      case 'gray':
        return const Color(0xFF607D8B);
      case 'orange':
        return const Color(0xFFFF5722);
      case 'yellow':
        return const Color(0xFFFFEB3B);
      case 'brown':
        return const Color(0xFF795548);
      case 'indigo':
        return const Color(0xFF3F51B5);
      case 'darkgrey':
      case 'darkgray':
        return const Color(0xFF757575);
      default:
        return const Color(0xFF2196F3); // Default blue
    }
  }

  /// Check if color is dark
  static bool isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// Check if color is light
  static bool isLight(Color color) {
    return !isDark(color);
  }

  /// Generate random color
  static Color randomColor() {
    return Color(
      (0xFFFFFF * (1.0 - (0.5 - 0.5))).toInt(),
    ).withValues(alpha: 1.0);
  }

  /// Get material color from single color
  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = ((color.r * 255.0).round() & 0xff);
    final g = ((color.g * 255.0).round() & 0xff);
    final b = ((color.b * 255.0).round() & 0xff);

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.toARGB32(), swatch);
  }
}
