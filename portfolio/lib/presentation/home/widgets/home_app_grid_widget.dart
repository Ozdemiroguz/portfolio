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
    // Combine apps and folders into a single list
    final allItems = <_GridItem>[];
    
    // Add apps
    for (var app in homeApps) {
      allItems.add(_GridItem.app(app));
    }
    
    // Add folders
    for (var folder in folders) {
      allItems.add(_GridItem.folder(folder));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate icon size and spacing
        final iconSize = AppSizes.appIconSize;
        final iconWidth = iconSize + 20; // icon + padding
        final padding = AppSizes.paddingLg;
        final spacing = AppSizes.spacingLg;
        
        // Determine minimum columns based on screen size
        final isTablet = constraints.maxWidth >= AppSizes.tabletBreakpoint;
        final minColumns = isTablet ? 3 : 2;
        
        // Calculate how many columns fit
        final availableWidth = constraints.maxWidth - (padding * 2);
        final calculatedColumns = ((availableWidth + spacing) / (iconWidth + spacing)).floor();
        final crossAxisCount = calculatedColumns.clamp(minColumns, 4);
        
        return Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: AppSizes.spacingMd, // Dikey boşluk azaltıldı
              childAspectRatio: iconWidth / (iconSize + 35), // Dikey yükseklik azaltıldı
            ),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              return Center(
                child: SizedBox(
                  width: iconWidth,
                  child: item.isApp
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
