import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/folder.dart';
import '../models/app.dart';
import 'app_icon.dart';

enum ResponsiveMode { extraSmall, small, medium, large }

class SimpleFolderOverlay extends StatelessWidget {
  final Folder folder;
  final List<App> apps;
  final VoidCallback onClose;
  final Function(App) onAppTap;

  const SimpleFolderOverlay({
    super.key,
    required this.folder,
    required this.apps,
    required this.onClose,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive mode belirleme - HomeScreenWidget ile aynı
        final screenWidth = constraints.maxWidth;
        late ResponsiveMode mode;
        if (screenWidth < 300) {
          mode = ResponsiveMode.extraSmall;
        } else if (screenWidth < 350) {
          mode = ResponsiveMode.small;
        } else if (screenWidth < 400) {
          mode = ResponsiveMode.medium;
        } else {
          mode = ResponsiveMode.large;
        }

        return GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.4), // Koyu overlay
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Container'a tıklamayı engelle
                child: Container(
                  width: _getContainerWidth(mode),
                  height: _getContainerHeight(mode),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: Colors.white.withOpacity(0.1),
                        child: Column(
                          children: [
                            // Başlık
                            Container(
                              padding: EdgeInsets.all(_getTitlePadding(mode)),
                              child: Text(
                                folder.title,
                                style: TextStyle(
                                  fontSize: _getTitleFontSize(mode),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            // App grid
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _getGridPadding(mode),
                                  vertical: 10,
                                ),
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: _getGridSpacing(mode),
                                        mainAxisSpacing: _getGridSpacing(mode),
                                        childAspectRatio: 1,
                                      ),
                                  itemCount: apps.length,
                                  itemBuilder: (context, index) {
                                    final app = apps[index];
                                    return AppIcon(
                                      title: app.title,
                                      app: app,
                                      size: 50,
                                      onTap: () => onAppTap(app),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Alt boşluk
                            SizedBox(height: _getBottomSpacing(mode)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getContainerWidth(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 280; // KÜÇÜK EKRANLARDA DAHA KÜÇÜK
      case ResponsiveMode.small:
        return 300;
      case ResponsiveMode.medium:
        return 320;
      case ResponsiveMode.large:
        return 350;
    }
  }

  double _getContainerHeight(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 400; // KÜÇÜK EKRANLARDA DAHA KÜÇÜK
      case ResponsiveMode.small:
        return 420;
      case ResponsiveMode.medium:
        return 450;
      case ResponsiveMode.large:
        return 480;
    }
  }

  double _getTitlePadding(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 15;
      case ResponsiveMode.small:
        return 20;
      case ResponsiveMode.medium:
        return 25;
      case ResponsiveMode.large:
        return 25;
    }
  }

  double _getTitleFontSize(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 20;
      case ResponsiveMode.small:
        return 22;
      case ResponsiveMode.medium:
        return 24;
      case ResponsiveMode.large:
        return 26;
    }
  }

  double _getGridPadding(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 15;
      case ResponsiveMode.small:
        return 20;
      case ResponsiveMode.medium:
        return 25;
      case ResponsiveMode.large:
        return 25;
    }
  }

  double _getGridSpacing(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 12; // DAHA AZ SPACING
      case ResponsiveMode.small:
        return 15;
      case ResponsiveMode.medium:
        return 18;
      case ResponsiveMode.large:
        return 20;
    }
  }

  double _getBottomSpacing(ResponsiveMode mode) {
    switch (mode) {
      case ResponsiveMode.extraSmall:
        return 15;
      case ResponsiveMode.small:
        return 18;
      case ResponsiveMode.medium:
        return 20;
      case ResponsiveMode.large:
        return 20;
    }
  }
}
