import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalizationService {
  Map<String, dynamic> _localizedStrings = {};
  String _currentLocale = 'tr';

  Future<void> loadLocale(String locale) async {
    _currentLocale = locale;
    final jsonString = await rootBundle.loadString('assets/lang/$locale.json');
    _localizedStrings = json.decode(jsonString);
  }

  String translate(String key) {
    final keys = key.split('.');
    dynamic current = _localizedStrings;

    for (final k in keys) {
      if (current is Map && current.containsKey(k)) {
        current = current[k];
      } else {
        return key;
      }
    }

    return current?.toString() ?? key;
  }

  String get currentLocale => _currentLocale;
}

final localizationServiceProvider = Provider<LocalizationService>((ref) {
  return LocalizationService();
});

final currentLocaleProvider = StateProvider<String>((ref) => 'tr');

extension LocalizationExtension on String {
  String tr(WidgetRef ref) {
    return ref.read(localizationServiceProvider).translate(this);
  }
}
