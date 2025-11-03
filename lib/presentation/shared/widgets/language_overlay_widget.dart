import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Language overlay widget
/// Displays language selection in an overlay
class LanguageOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;

  const LanguageOverlayWidget({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

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
                    // Title
                    Text(
                      tr('app.language'),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingLg),

                    // Language options
                    _buildLanguageOption(
                      context: context,
                      locale: const Locale('en'),
                      label: tr('app.english'),
                      icon: '🇬🇧',
                      isSelected: currentLocale.languageCode == 'en',
                      onTap: () async {
                        await context.setLocale(const Locale('en'));
                        // Dil değişikliğinin widget tree'ye yansıması için kısa bir gecikme
                        await Future.delayed(const Duration(milliseconds: 100));
                        onClose();
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingMd),
                    _buildLanguageOption(
                      context: context,
                      locale: const Locale('tr'),
                      label: tr('app.turkish'),
                      icon: '🇹🇷',
                      isSelected: currentLocale.languageCode == 'tr',
                      onTap: () async {
                        await context.setLocale(const Locale('tr'));
                        // Dil değişikliğinin widget tree'ye yansıması için kısa bir gecikme
                        await Future.delayed(const Duration(milliseconds: 100));
                        onClose();
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

  Widget _buildLanguageOption({
    required BuildContext context,
    required Locale locale,
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLg,
          vertical: AppSizes.paddingMd,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.withOpacity(Colors.white, 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.withOpacity(Colors.white, 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: AppSizes.spacingMd),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}


