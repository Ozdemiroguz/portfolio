import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/achievement_data_entity.dart';
import 'achievement_card_widget.dart';

/// Achievement list widget
/// Displays all achievements
class AchievementListWidget extends StatelessWidget {
  final AchievementDataEntity data;

  const AchievementListWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = data.achievements;

    if (achievements.isEmpty) {
      return Center(
        child: Text(
          tr('achievement.noAchievementsAvailable'),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: achievements.map((achievement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingLg),
          child: AchievementCardWidget(
            achievement: achievement,
          ),
        );
      }).toList(),
    );
  }
}
