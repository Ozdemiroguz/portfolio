import 'package:flutter/material.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../shared/widgets/app_icon_widget.dart';

/// Home dock widget
/// Displays bottom dock with apps
class HomeDockWidget extends StatelessWidget {
  final List<AppEntity> bottomApps;
  final Function(AppEntity) onAppTap;

  const HomeDockWidget({
    super.key,
    required this.bottomApps,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Icon boyutunu ekran genişliğine göre ayarla
    final iconSize = screenWidth < AppSizes.tabletBreakpoint
        ? AppSizes.appIconSizeSmall
        : AppSizes.appIconSizeSmall * 0.85;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.paddingSm,
        horizontal: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: bottomApps.map((app) {
          return Expanded(
            child: Center(
              child: AppIconWidget(
                app: app,
                onTap: () => onAppTap(app),
                size: iconSize,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
