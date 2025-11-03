import 'package:flutter/material.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/entities/folder_entity.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/home_app_grid_widget.dart';
import 'widgets/home_dock_widget.dart';

/// Home screen
/// Displays app icons, folders, and dock
class HomeScreen extends StatelessWidget {
  final List<AppEntity> homeApps;
  final List<AppEntity> bottomApps;
  final List<FolderEntity> folders;
  final Function(AppEntity) onAppTap;
  final Function(FolderEntity) onFolderTap;

  const HomeScreen({
    super.key,
    required this.homeApps,
    required this.bottomApps,
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
          colors: AppColors.backgroundGradient,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App grid (scrollable)
            Expanded(
              child: HomeAppGridWidget(
                homeApps: homeApps,
                folders: folders,
                onAppTap: onAppTap,
                onFolderTap: onFolderTap,
              ),
            ),

            // Dock
            HomeDockWidget(bottomApps: bottomApps, onAppTap: onAppTap),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}
