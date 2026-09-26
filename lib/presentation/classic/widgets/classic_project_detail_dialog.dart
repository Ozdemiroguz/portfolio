import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/app_entity.dart';
import '../../projects/projects_screen.dart';

/// Shows the existing project detail screen inside a dialog.
Future<void> showClassicProjectDetail(BuildContext context, AppEntity app) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.withOpacity(Colors.black, 0.7),
    builder: (context) => ClassicProjectDetailDialog(app: app),
  );
}

class ClassicProjectDetailDialog extends StatelessWidget {
  final AppEntity app;

  const ClassicProjectDetailDialog({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width - 2 * AppSizes.paddingLg).clamp(280.0, 560.0);
    final height = (size.height - 2 * AppSizes.paddingLg).clamp(320.0, 860.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSizes.paddingLg),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.backgroundGradient,
              ),
            ),
            child: Stack(
              children: [
                ProjectsScreen(app: app),
                Positioned(
                  top: AppSizes.paddingMd,
                  right: AppSizes.paddingMd,
                  child: Tooltip(
                    message: tr('classic.close'),
                    child: Material(
                      color: AppColors.withOpacity(Colors.black, 0.5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(AppSizes.paddingSm),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: AppSizes.iconSm,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
