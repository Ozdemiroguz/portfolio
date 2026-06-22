import 'package:flutter/material.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../domain/entities/folder_entity.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/app_icon_widget.dart';
import '../../shared/widgets/folder_icon_widget.dart';

/// Home app grid widget
/// Displays apps and folders in a grid
class HomeAppGridWidget extends StatelessWidget {
  final List<AppEntity> homeApps;
  final List<FolderEntity> folders;
  final Function(AppEntity) onAppTap;
  final Function(FolderEntity) onFolderTap;

  const HomeAppGridWidget({
    super.key,
    required this.homeApps,
    required this.folders,
    required this.onAppTap,
    required this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1) Sort apps by order field (recruiter-friendly priority)
    final sortedApps = [...homeApps]
      ..sort((a, b) => a.order.compareTo(b.order));

    // 2) Sort folders by order field
    final sortedFolders = [...folders]
      ..sort((a, b) => a.order.compareTo(b.order));

    // 3) Build final list — folders insert after first 3 apps (About, CV, Career)
    // so Indie Apps + Projects appear high in the grid (before Achievement, Contact, etc.)
    final allItems = <_GridItem>[];
    const folderInsertAfterIndex = 3;

    for (var i = 0; i < sortedApps.length; i++) {
      allItems.add(_GridItem.app(sortedApps[i]));
      if (i == folderInsertAfterIndex - 1) {
        for (var folder in sortedFolders) {
          allItems.add(_GridItem.folder(folder));
        }
      }
    }
    // Fallback: if fewer than folderInsertAfterIndex apps, append folders at end
    if (sortedApps.length < folderInsertAfterIndex) {
      for (var folder in sortedFolders) {
        allItems.add(_GridItem.folder(folder));
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate icon size and spacing
        final iconSize = AppSizes.appIconSize;
        final iconWidth = iconSize + 20; // icon + padding
        final padding = AppSizes.paddingLg;
        final spacing = AppSizes.spacingLg;

        // Tüm ekran boyutlarında minimum 3 kolon kullan
        final minColumns = 3;

        // Calculate how many columns fit
        final availableWidth = constraints.maxWidth - (padding * 2);
        final calculatedColumns =
            ((availableWidth + spacing) / (iconWidth + spacing)).floor();
        final crossAxisCount = calculatedColumns.clamp(minColumns, 4);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
          child: GridView.builder(
            //top padding 16
            padding: const EdgeInsets.only(top: 16),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: AppSizes.spacingMd,
              childAspectRatio: iconWidth / (iconSize + 35),
            ),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              return Center(
                child: SizedBox(
                  width: iconWidth,
                  child:
                      item.isApp
                          ? AppIconWidget(
                            app: item.app!,
                            onTap: () => onAppTap(item.app!),
                          )
                          : FolderIconWidget(
                            folder: item.folder!,
                            onTap: () => onFolderTap(item.folder!),
                          ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Helper class to combine apps and folders
class _GridItem {
  final AppEntity? app;
  final FolderEntity? folder;

  _GridItem.app(this.app) : folder = null;
  _GridItem.folder(this.folder) : app = null;

  bool get isApp => app != null;
}
