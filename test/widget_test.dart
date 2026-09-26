import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/di/injection.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/presentation/classic/classic_portfolio_screen.dart';
import 'package:portfolio/presentation/home/home_screen.dart';
import 'package:portfolio/presentation/view_mode/view_mode_cubit.dart';
import 'package:portfolio/presentation/view_mode/view_mode_toggle_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loads translation files synchronously so localization never waits on
/// real I/O inside the fake-async test zone.
class _SyncTranslationsLoader extends AssetLoader {
  const _SyncTranslationsLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final file = File('$path/${locale.languageCode}.json');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

Future<void> _bootApp(
  WidgetTester tester, {
  required Size viewport,
  Map<String, Object> storedPrefs = const {},
}) async {
  // The layout targets a browser window; make the test surface match one.
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(storedPrefs);
  await EasyLocalization.ensureInitialized();
  await sl.reset();
  await initializeDependencies();

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: const _SyncTranslationsLoader(),
      child: const MyApp(),
    ),
  );

  // The data source simulates network latency with timers, which only
  // advance when fake time is pumped.
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('desktop boots into the phone experience', (tester) async {
    await _bootApp(tester, viewport: const Size(1440, 900));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ViewModeToggleWidget), findsOneWidget);
  });

  testWidgets('toggle switches to the classic layout and back',
      (tester) async {
    await _bootApp(tester, viewport: const Size(1440, 900));

    Finder toggleIcon(IconData icon) => find.descendant(
          of: find.byType(ViewModeToggleWidget),
          matching: find.byIcon(icon),
        );

    await tester.tap(toggleIcon(Icons.web));
    await tester.pumpAndSettle();
    expect(find.byType(ClassicPortfolioScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    await tester.tap(toggleIcon(Icons.phone_iphone));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ClassicPortfolioScreen), findsNothing);
  });

  testWidgets('stored preference opens the classic layout', (tester) async {
    await _bootApp(
      tester,
      viewport: const Size(1440, 900),
      storedPrefs: {ViewModeCubit.prefsKey: ViewMode.classic.name},
    );

    expect(find.byType(ClassicPortfolioScreen), findsOneWidget);
  });

  testWidgets('narrow viewports default to the classic layout',
      (tester) async {
    await _bootApp(tester, viewport: const Size(390, 844));

    expect(find.byType(ClassicPortfolioScreen), findsOneWidget);
  });
}
