import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/url_helpers.dart';

/// Project links widget
/// Displays project external links (GitHub, stores, etc.)
class ProjectLinksWidget extends StatelessWidget {
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? linkedinUrl;
  final String? webUrl;

  const ProjectLinksWidget({
    super.key,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.linkedinUrl,
    this.webUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we have any links
    if (githubUrl == null &&
        playStoreUrl == null &&
        appStoreUrl == null &&
        linkedinUrl == null &&
        webUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSizes.spacingSm,
          runSpacing: AppSizes.spacingSm,
          children: [
            if (githubUrl != null)
              _buildLinkButton(tr('projects.github'), Icons.code, githubUrl),
            if (playStoreUrl != null)
              _buildLinkButton(
                  tr('projects.playStore'), Icons.android, playStoreUrl),
            if (appStoreUrl != null)
              _buildLinkButton(tr('projects.appStore'), Icons.apple, appStoreUrl),
            if (linkedinUrl != null)
              _buildLinkButton(tr('projects.linkedin'), Icons.work, linkedinUrl),
            if (webUrl != null)
              _buildLinkButton(tr('projects.website'), Icons.language, webUrl),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildLinkButton(String label, IconData icon, String? url) {
    final bool isActive = url != null && url.isNotEmpty;

    return ElevatedButton.icon(
      onPressed: isActive ? () => UrlHelpers.launchURL(url) : null,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive
            ? AppColors.withOpacity(AppColors.primary, 0.2)
            : AppColors.withOpacity(Colors.grey, 0.1),
        foregroundColor:
            isActive ? AppColors.textPrimary : AppColors.textSecondary,
        disabledBackgroundColor: AppColors.withOpacity(Colors.grey, 0.1),
        disabledForegroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

