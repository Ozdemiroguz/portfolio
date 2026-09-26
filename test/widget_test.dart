import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/di/injection.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/presentation/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    await initializeDependencies();
  });

  testWidgets('app boots and renders the home screen', (tester) async {
    // The layout targets a desktop browser window; the default 800x600 test
    // surface is smaller than any real viewport the site is served at.
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );

    // Let localization load and the simulated data delays elapse.
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
