import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/app.dart';
import '../models/folder.dart';
import '../services/firebase_service.dart';
import 'home_screen_widget.dart';
import 'app_screen_widget.dart';
import 'simple_folder_overlay.dart';

class PhoneUI extends StatefulWidget {
  final String domain;

  const PhoneUI({super.key, required this.domain});

  @override
  State<PhoneUI> createState() => _PhoneUIState();
}

class _PhoneUIState extends State<PhoneUI> {
  List<App> _homeApps = [];
  List<App> _bottomApps = [];
  List<App> _allApps = []; // Tüm app'ler (folder preview için)
  List<Folder> _folders = [];
  bool _isLoading = true;
  String? _error;

  // Navigation state
  App? _openApp;
  Folder? _openFolder;
  List<App> _folderApps = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final firebaseService = FirebaseService();

      final results = await Future.wait([
        firebaseService.getHomeApps(widget.domain),
        firebaseService.getBottomApps(widget.domain),
        firebaseService.getFolders(widget.domain),
      ]);

      final homeApps = results[0] as List<App>;
      final bottomApps = results[1] as List<App>;
      final folders = results[2] as List<Folder>;

      // Tüm folder app'lerini yükle
      List<App> folderApps = [];
      for (final folder in folders) {
        if (folder.appIds.isNotEmpty) {
          final apps = await firebaseService.getAppsInFolder(
            widget.domain,
            folder.appIds,
          );
          folderApps.addAll(apps);
        }
      }

      // Tüm app'leri birleştir (home + bottom + folder apps)
      final allApps = <App>[];
      allApps.addAll(homeApps);
      allApps.addAll(bottomApps);
      allApps.addAll(folderApps);

      setState(() {
        _homeApps = homeApps;
        _bottomApps = bottomApps;
        _allApps = allApps; // Tüm app'ler birleştirildi
        _folders = folders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openAppScreen(App app) {
    setState(() {
      _openApp = app;
    });
  }

  void _openFolderScreen(Folder folder) async {
    // Folder'ın app'lerini yükle
    final firebaseService = FirebaseService();
    final folderApps = await firebaseService.getAppsInFolder(
      widget.domain,
      folder.appIds,
    );

    setState(() {
      _openFolder = folder;
      _folderApps = folderApps;
    });
  }

  void _closeApp() {
    setState(() {
      _openApp = null;
    });
  }

  void _closeFolder() {
    setState(() {
      _openFolder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildScreenContent();
  }

  Widget _buildScreenContent() {
    if (_isLoading) {
      return const LoadingScreenWidget();
    }

    if (_error != null) {
      return ErrorScreenWidget(error: _error!, onRetry: _loadData);
    }

    // App screen
    if (_openApp != null) {
      return AppScreenWidget(openApp: _openApp!, onBackPressed: _closeApp);
    }

    // Home screen with optional folder overlay
    return Stack(
      children: [
        // Ana home screen
        HomeScreenWidget(
          allApps: _allApps, // 🎯 TÜM APP'LER (home + bottom + folder)
          homeApps: _homeApps,
          bottomApps: _bottomApps,
          folders: _folders,
          onAppTap: _openAppScreen,
          onFolderTap: _openFolderScreen,
        ),

        // Folder overlay - sadece home screen üzerinde
        if (_openFolder != null)
          SimpleFolderOverlay(
            folder: _openFolder!,
            apps: _folderApps,
            onClose: _closeFolder,
            onAppTap: _openAppScreen,
          ),
      ],
    );
  }
}

class LoadingScreenWidget extends StatelessWidget {
  const LoadingScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            SizedBox(height: 20),
            Text(
              'Yükleniyor...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreenWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorScreenWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 20),
              const Text(
                'Bir hata oluştu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                error,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Tekrar Dene',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
