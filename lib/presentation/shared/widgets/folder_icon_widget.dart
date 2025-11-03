import 'package:flutter/material.dart';
import '../../../domain/entities/folder_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/color_helpers.dart';

/// Folder icon widget
/// Displays a folder icon with label
class FolderIconWidget extends StatelessWidget {
  final FolderEntity folder;
  final VoidCallback onTap;

  const FolderIconWidget({
    super.key,
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final folderColor = ColorHelpers.parseHexColor(folder.color);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.appIconSize + 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Folder icon container
            Container(
              width: AppSizes.appIconSize,
              height: AppSizes.appIconSize,
              decoration: BoxDecoration(
                color: AppColors.withOpacity(folderColor, 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: AppColors.withOpacity(folderColor, 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  folder.icon.isNotEmpty ? folder.icon : '📁',
                  style: TextStyle(fontSize: AppSizes.appIconSize * 0.5),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spacingXs),

            // Label
            Text(
              folder.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
