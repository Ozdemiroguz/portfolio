import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/achievement_data_entity.dart';

/// Achievement card widget
/// Displays a single achievement
class AchievementCardWidget extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementCardWidget({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final title = achievement.title;
    final description = achievement.description;
    final issuer = achievement.issuer;
    final date = achievement.date;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.withOpacity(Colors.white, 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trophy icon and title
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.accent,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSizes.spacingMd),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Issuer
          if (issuer.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingSm),
            Text(
              issuer,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          // Date
          if (date.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingXs),
            Text(
              _formatDate(date),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],

          // Description
          if (description.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateHelpers.parseDateTime(date);
      return DateHelpers.formatDateFull(parsedDate);
    } catch (e) {
      return date;
    }
  }
}
