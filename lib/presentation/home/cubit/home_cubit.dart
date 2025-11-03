import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../domain/entities/folder_entity.dart';
import '../../../domain/usecases/get_home_apps.dart';
import '../../../domain/usecases/get_bottom_apps.dart';
import '../../../domain/usecases/get_folders.dart';
import '../../../domain/usecases/get_folder_apps.dart';
import 'home_state.dart';

/// Home cubit
/// Manages home screen state
class HomeCubit extends Cubit<HomeState> {
  final GetHomeApps getHomeApps;
  final GetBottomApps getBottomApps;
  final GetFolders getFolders;
  final GetFolderApps getFolderApps;

  HomeCubit({
    required this.getHomeApps,
    required this.getBottomApps,
    required this.getFolders,
    required this.getFolderApps,
  }) : super(const HomeInitial());

  /// Load home data
  Future<void> loadHomeData(String domain) async {
    emit(const HomeLoading());

    try {
      // Load all data in parallel
      final results = await Future.wait([
        getHomeApps(domain),
        getBottomApps(domain),
        getFolders(domain),
      ]);

      final homeAppsResult = results[0] as List<AppEntity>;
      final bottomAppsResult = results[1] as List<AppEntity>;
      final foldersResult = results[2] as List<FolderEntity>;

      emit(HomeLoaded(
        homeApps: homeAppsResult,
        bottomApps: bottomAppsResult,
        folders: foldersResult,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Open app
  void openApp(AppEntity app, BuildContext? context) {
    // Language app için dil seçim overlay'i aç
    if (app.type == 'language') {
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(showLanguageOverlay: true));
      }
      return;
    }

    // Browser app için direkt Google.com'u harici tarayıcıda aç
    if (app.type == 'browser') {
      _openGoogleInBrowser();
      return;
    }

    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(
        openApp: app,
        clearOpenFolder: true,
        showLanguageOverlay: false,
      ));
    }
  }

  /// Open Google.com in external browser
  Future<void> _openGoogleInBrowser() async {
    const url = 'https://www.google.com';
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }

  /// Close language overlay
  void closeLanguageOverlay() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(showLanguageOverlay: false));
    }
  }

  /// Close app
  void closeApp() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(clearOpenApp: true));
    }
  }

  /// Open folder
  Future<void> openFolder(String domain, FolderEntity folder) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    try {
      // Load folder apps
      final apps = await getFolderApps(domain, folder.appIds);

      emit(currentState.copyWith(
        openFolder: folder,
        folderApps: apps,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Close folder
  void closeFolder() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(
        clearOpenFolder: true,
        folderApps: [],
      ));
    }
  }
}
