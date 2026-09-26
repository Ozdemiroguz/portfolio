import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How the portfolio is presented.
enum ViewMode {
  /// The interactive iOS-style phone experience.
  phone,

  /// A conventional single-page portfolio layout.
  classic;

  static ViewMode? fromName(String? name) {
    for (final mode in values) {
      if (mode.name == name) return mode;
    }
    return null;
  }
}

/// Holds the user's explicit view mode choice.
///
/// The state is `null` while the user has not chosen a mode; the screen then
/// picks a sensible default from the viewport size. A choice made through the
/// `?view=` query parameter wins over the stored preference for that visit.
class ViewModeCubit extends Cubit<ViewMode?> {
  static const prefsKey = 'view_mode';
  static const queryParam = 'view';

  final SharedPreferences prefs;

  ViewModeCubit({required this.prefs, Uri? initialUri})
      : super(_initialMode(prefs, initialUri ?? Uri.base));

  static ViewMode? _initialMode(SharedPreferences prefs, Uri uri) {
    return ViewMode.fromName(uri.queryParameters[queryParam]) ??
        ViewMode.fromName(prefs.getString(prefsKey));
  }

  /// Select a mode and remember it for future visits.
  Future<void> select(ViewMode mode) async {
    emit(mode);
    await prefs.setString(prefsKey, mode.name);
  }

  /// Resolves the mode to display for a viewport of [width].
  ///
  /// Without an explicit choice, narrow (mobile) viewports get the classic
  /// layout because a phone frame inside a phone is redundant.
  ViewMode resolve(double width, {double mobileBreakpoint = 768}) {
    return state ?? (width < mobileBreakpoint ? ViewMode.classic : ViewMode.phone);
  }
}
