import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/app.dart';
import '../models/folder.dart';
import 'folder_icon.dart';
import 'app_icon.dart';

enum ResponsiveMode { extraSmall, small, medium, large }

class HomeScreenWidget extends StatelessWidget {
  final List<App> homeApps;
  final List<App> bottomApps;
  final List<App> allApps; // Tüm app'ler (folder app'leri için)
  final List<Folder> folders;
  final Function(App) onAppTap;
  final Function(Folder) onFolderTap;

  const HomeScreenWidget({
    super.key,
    required this.homeApps,
    required this.bottomApps,
    required this.allApps, // Yeni parametre
    required this.folders,
    required this.onAppTap,
    required this.onFolderTap,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          ResponsiveMode mode = _getResponsiveMode(constraints.maxWidth);

          return SafeArea(
            child: Padding(
              padding: _getPadding(mode),
              child: Column(
                children: [
                  // Ana app grid'i
                  Expanded(
                    child: ClipRRect(
                      child: MainAppGridWidget(
                        homeApps: homeApps,
                        allApps: allApps, // Tüm app'leri geç
                        folders: folders,
                        onAppTap: onAppTap,
                        onFolderTap: onFolderTap,
                        mode: mode,
                      ),
                    ),
                  ),

                  // Alt dock
                  BottomDockWidget(
                    bottomApps: bottomApps,
                    onAppTap: onAppTap,
                    mode: mode,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  EdgeInsets _getPadding(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return const EdgeInsets.symmetric(horizontal: 5, vertical: 5);
      case ResponsiveMode.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case ResponsiveMode.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ResponsiveMode.large:
        return const EdgeInsets.symmetric(horizontal: 15, vertical: 10);
    }
  }

  ResponsiveMode _getResponsiveMode(double screenWidth) {
    if (screenWidth < 300) {
      return ResponsiveMode.extraSmall;
    } else if (screenWidth < 350) {
      return ResponsiveMode.small;
    } else if (screenWidth < 400) {
      return ResponsiveMode.medium;
    } else {
      return ResponsiveMode.large;
    }
  }
}

class MainAppGridWidget extends StatelessWidget {
  final List<App> homeApps;
  final List<App> allApps; // Tüm app'ler
  final List<Folder> folders;
  final Function(App) onAppTap;
  final Function(Folder) onFolderTap;
  final ResponsiveMode mode;

  const MainAppGridWidget({
    super.key,
    required this.homeApps,
    required this.allApps, // Yeni parametre
    required this.folders,
    required this.onAppTap,
    required this.onFolderTap,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    // Mode'a göre değerler
    final spacing = _getSpacing(mode);
    final crossAxisCount = _getCrossAxisCount(mode);
    final childAspectRatio = _getChildAspectRatio(mode);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: homeApps.length + folders.length,
      itemBuilder: (context, index) {
        if (index < homeApps.length) {
          // App icon
          final app = homeApps[index];
          return AppIcon(
            title: app.title,
            app: app,
            size: _getIconSize(mode),
            onTap: () => onAppTap(app),
          );
        } else {
          // Folder icon
          final folderIndex = index - homeApps.length;
          final folder = folders[folderIndex];

          // Folder'ın app'lerini bul
          final folderApps =
              allApps.where((app) => folder.appIds.contains(app.id)).toList();

          return FolderIcon(
            folder: folder,
            apps: folderApps, // Folder'ın gerçek app'leri
            size: _getIconSize(mode), // AppIcon ile aynı responsive size
            onTap: () => onFolderTap(folder),
          );
        }
      },
    );
  }

  double _getSpacing(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 6.0;
      case ResponsiveMode.small:
        return 8.0;
      case ResponsiveMode.medium:
        return 10.0;
      case ResponsiveMode.large:
        return 12.0;
    }
  }

  int _getCrossAxisCount(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 3; // Telefon modunda 3 uygulama
      case ResponsiveMode.small:
        return 3; // Telefon modunda 3 uygulama
      case ResponsiveMode.medium:
        return 4;
      case ResponsiveMode.large:
        return 4;
    }
  }

  double _getChildAspectRatio(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
      case ResponsiveMode.small:
        return 0.8; // Daha kısa iconlar
      case ResponsiveMode.medium:
        return 0.9;
      case ResponsiveMode.large:
        return 1.0;
    }
  }

  double _getIconSize(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 42.0;
      case ResponsiveMode.small:
        return 45.0;
      case ResponsiveMode.medium:
        return 48.0;
      case ResponsiveMode.large:
        return 52.0;
    }
  }
}

class BottomDockWidget extends StatelessWidget {
  final List<App> bottomApps;
  final Function(App) onAppTap;
  final ResponsiveMode mode;

  const BottomDockWidget({
    super.key,
    required this.bottomApps,
    required this.onAppTap,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final padding = _getPadding(mode);
    final margin = _getMargin(mode);
    final borderRadius = _getBorderRadius(mode);
    final iconSize = _getIconSize(mode);

    // DOCK HEIGHT = SADECE ICON BOYUTU + MINIMAL PADDING
    final height = iconSize + padding.vertical + 16; // Minimal extra space

    return Center(
      child: Container(
        height: height,
        margin: margin,
        padding: padding,
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.75, // Daha dar tutup uzat
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              bottomApps.map((app) {
                return _buildBottomDockIcon(app, iconSize);
              }).toList(),
        ),
      ),
    );
  }

  // _getHeight artık gerekli değil - otomatik hesaplanıyor

  EdgeInsets _getPadding(ResponsiveMode mode) {
    // MİNİMAL PADDİNG - SADECE ROW ORTALANSIN
    return const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  }

  EdgeInsets _getMargin(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return const EdgeInsets.only(top: 0); // TELEFON MODUNDA MARGIN SIFIR
      case ResponsiveMode.small:
        return const EdgeInsets.only(top: 0); // TELEFON MODUNDA MARGIN SIFIR
      case ResponsiveMode.medium:
        return const EdgeInsets.only(top: 4);
      case ResponsiveMode.large:
        return const EdgeInsets.only(top: 5);
    }
  }

  double _getBorderRadius(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 20; // Makul border radius
      case ResponsiveMode.small:
        return 22;
      case ResponsiveMode.medium:
        return 25;
      case ResponsiveMode.large:
        return 28;
    }
  }

  double _getIconSize(ResponsiveMode mode) {
    // NORMAL GRID GİBİ BOYUTLAR
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 42.0; // Normal grid ile aynı
      case ResponsiveMode.small:
        return 45.0;
      case ResponsiveMode.medium:
        return 48.0;
      case ResponsiveMode.large:
        return 52.0;
    }
  }

  Widget _buildBottomDockIcon(App app, double iconSize) {
    return AppIcon(
      title: app.title,
      app: app,
      size: iconSize,
      showTitle: false, // Bottom dock'ta text gizle
      onTap: () => onAppTap(app),
    );
  }
}
