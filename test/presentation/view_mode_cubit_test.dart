import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/presentation/view_mode/view_mode_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SharedPreferences> prefsWith(Map<String, Object> values) {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  group('ViewModeCubit', () {
    test('has no explicit mode when nothing is stored', () async {
      final cubit = ViewModeCubit(
        prefs: await prefsWith({}),
        initialUri: Uri.parse('https://example.com/'),
      );

      expect(cubit.state, isNull);
      expect(cubit.resolve(1440), ViewMode.phone);
      expect(cubit.resolve(390), ViewMode.classic);
    });

    test('reads the stored preference', () async {
      final cubit = ViewModeCubit(
        prefs: await prefsWith({ViewModeCubit.prefsKey: 'classic'}),
        initialUri: Uri.parse('https://example.com/'),
      );

      expect(cubit.state, ViewMode.classic);
      expect(cubit.resolve(1440), ViewMode.classic);
    });

    test('query parameter wins over the stored preference', () async {
      final cubit = ViewModeCubit(
        prefs: await prefsWith({ViewModeCubit.prefsKey: 'classic'}),
        initialUri: Uri.parse('https://example.com/?view=phone'),
      );

      expect(cubit.state, ViewMode.phone);
    });

    test('ignores unknown values', () async {
      final cubit = ViewModeCubit(
        prefs: await prefsWith({ViewModeCubit.prefsKey: 'bogus'}),
        initialUri: Uri.parse('https://example.com/?view=nope'),
      );

      expect(cubit.state, isNull);
    });

    test('select persists the choice', () async {
      final prefs = await prefsWith({});
      final cubit = ViewModeCubit(
        prefs: prefs,
        initialUri: Uri.parse('https://example.com/'),
      );

      await cubit.select(ViewMode.classic);

      expect(cubit.state, ViewMode.classic);
      expect(prefs.getString(ViewModeCubit.prefsKey), 'classic');
    });
  });
}
