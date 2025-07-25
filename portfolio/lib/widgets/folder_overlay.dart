import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/folder.dart';
import '../models/app.dart';
import 'app_icon.dart';

class FolderOverlay extends StatefulWidget {
  final Folder folder;
  final List<App> apps;
  final VoidCallback onClose;
  final Function(App) onAppTap;

  const FolderOverlay({
    super.key,
    required this.folder,
    required this.apps,
    required this.onClose,
    required this.onAppTap,
  });

  @override
  State<FolderOverlay> createState() => _FolderOverlayState();
}

class _FolderOverlayState extends State<FolderOverlay> {
  late PageController _pageController;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _calculatePages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _calculatePages() {
    const appsPerPage = 9; // 3x3 grid
    _totalPages = (widget.apps.length / appsPerPage).ceil();
    if (_totalPages == 0) _totalPages = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Arka plan blur - tüm alanı kapla
          _buildBlurBackground(),

          // Folder container - merkez
          Center(child: _buildFolderContainer()),
        ],
      ),
    );
  }

  Widget _buildBlurBackground() {
    return GestureDetector(
      onTap: widget.onClose, // Arka plana tıklayınca kapat
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.3), // Açık tonlu overlay
        ),
      ),
    );
  }

  Widget _buildFolderContainer() {
    return SizedBox(
      width: 320,
      height: 450,
      child: Column(
        children: [
          // Folder title
          _buildFolderTitle(),

          const SizedBox(height: 20),

          // Blur container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Column(
                      children: [
                        // Apps grid
                        Expanded(child: _buildAppsGrid()),

                        // Page indicators
                        if (_totalPages > 1) _buildPageIndicators(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderTitle() {
    return Text(
      widget.folder.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAppsGrid() {
    if (widget.apps.isEmpty) {
      return const Center(
        child: Text(
          'No apps in this folder',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (page) {
        _currentPage = page;
      },
      itemCount: _totalPages,
      itemBuilder: (context, pageIndex) {
        return _buildAppPage(pageIndex);
      },
    );
  }

  Widget _buildAppPage(int pageIndex) {
    const appsPerPage = 9; // 3x3
    final startIndex = pageIndex * appsPerPage;
    final endIndex = (startIndex + appsPerPage).clamp(0, widget.apps.length);
    final pageApps = widget.apps.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // PageView handles scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1,
        ),
        itemCount: pageApps.length,
        itemBuilder: (context, index) {
          final app = pageApps[index];
          return AppIcon(
            title: app.title,
            app: app,
            size: 52,
            onTap: () => widget.onAppTap(app),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalPages, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
            ),
          );
        }),
      ),
    );
  }
}
