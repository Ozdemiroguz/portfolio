import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/folder_entity.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'app_icon_widget.dart';

/// Folder overlay widget
/// Displays folder contents in an overlay
class FolderOverlayWidget extends StatelessWidget {
  final FolderEntity folder;
  final List<AppEntity> apps;
  final VoidCallback onClose;
  final Function(AppEntity) onAppTap;

  const FolderOverlayWidget({
    super.key,
    required this.folder,
    required this.apps,
    required this.onClose,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 44,    // status bar only
        bottom: 34, // home indicator only
      ),
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: AppColors.withOpacity(Colors.black, 0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping inside
              child: Container(
                margin: const EdgeInsets.all(AppSizes.paddingXl),
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(Colors.black, 0.85),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: AppColors.withOpacity(Colors.white, 0.3),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Folder title
                    Text(
                      folder.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingLg),

                    // Apps in folder
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: AppSizes.spacingMd,
                        mainAxisSpacing: AppSizes.spacingMd,
                        childAspectRatio: 0.75, // width/height ratio
                      ),
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: SizedBox(
                            width: AppSizes.appIconSizeSmall + 20,
                            child: AppIconWidget(
                              app: apps[index],
                              size: AppSizes.appIconSizeSmall,
                              onTap: () {
                                onClose();
                                onAppTap(apps[index]);
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSizes.spacingLg),

                    // Close button
                    TextButton(
                      onPressed: onClose,
                      child: Text(tr('folder.close')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
