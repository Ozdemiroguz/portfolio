import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import 'widgets/about_profile_image_widget.dart';
import 'widgets/about_content_widget.dart';

/// About screen
/// Displays personal information about the portfolio owner
class AboutScreen extends StatelessWidget {
  final AppEntity app;

  const AboutScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    final aboutData = app.aboutData;

    if (aboutData == null) {
      return Center(
        child: Text(tr('about.noData')),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Top spacing for back button
          const SizedBox(height: 100),

          // Profile image from data
          AboutProfileImageWidget(imageUrl: aboutData.profileImage),

          const SizedBox(height: 20),

          // About content - full width
          AboutContentWidget(data: aboutData),
        ],
      ),
    );
  }
}
