import 'package:easy_localization/easy_localization.dart';

/// Translation helper utilities
/// Common translation operations used across the app
class TranslationHelpers {
  TranslationHelpers._(); // Private constructor

  /// Try to translate a key, return original value if translation fails or not found
  /// This is useful when we have optional translation keys
  static String tryTranslate(String? key, String originalValue) {
    if (key == null || key.isEmpty) {
      return originalValue;
    }

    try {
      final translated = tr(key);
      // If translation returns the same key (meaning translation not found), return original value
      if (translated == key) {
        return originalValue;
      }
      return translated;
    } catch (e) {
      return originalValue;
    }
  }

  /// Translate a list of keys, falling back to original values if translation fails
  static List<String> tryTranslateList(
    List<String>? keys,
    List<String> originalValues,
  ) {
    if (keys == null || keys.isEmpty || keys.length != originalValues.length) {
      return originalValues;
    }

    final List<String> translated = [];
    for (int i = 0; i < originalValues.length; i++) {
      translated.add(tryTranslate(keys[i], originalValues[i]));
    }
    return translated;
  }
}


