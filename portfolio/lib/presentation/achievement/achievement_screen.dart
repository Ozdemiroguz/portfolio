import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import 'widgets/achievement_list_widget.dart';
import '../about/widgets/about_profile_image_widget.dart';

/// Achievement screen
/// Displays awards and certificates
class AchievementScreen extends StatelessWidget {
  final AppEntity app;

  const AchievementScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    final achievementData = app.achievementData;

    if (achievementData == null) {
      return Center(
        child: Text(tr('achievement.noData')),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 100),

          // Profile image
          AboutProfileImageWidget(imageUrl: achievementData.profileImage),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AchievementListWidget(data: achievementData),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
