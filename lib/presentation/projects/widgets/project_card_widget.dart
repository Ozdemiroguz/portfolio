import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/project_data_entity.dart';
import '../../../core/utils/translation_helpers.dart';
import '../../../core/utils/url_helpers.dart';

/// Project card widget
/// Displays a single project
class ProjectCardWidget extends StatelessWidget {
  final ProjectEntity project;

  const ProjectCardWidget({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final title = TranslationHelpers.tryTranslate(project.titleKey, project.title);
    final description = TranslationHelpers.tryTranslate(project.descriptionKey, project.description);
    final technologies = project.technologies;
    final githubUrl = project.githubUrl;
    final playStoreUrl = project.playStoreUrl;
    final webUrl = project.webUrl;

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
          // Title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacingSm),

          // Description
          if (description.isNotEmpty)
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),

          // Technologies
          if (technologies.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMd),
            Wrap(
              spacing: AppSizes.spacingSm,
              runSpacing: AppSizes.spacingSm,
              children: technologies.map((tech) {
                return Chip(
                  label: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor:
                      AppColors.withOpacity(AppColors.primary, 0.2),
                  side: BorderSide(
                    color: AppColors.withOpacity(AppColors.primary, 0.4),
                  ),
                );
              }).toList(),
            ),
          ],

          // Links
          if (githubUrl != null || playStoreUrl != null || webUrl != null) ...[
            const SizedBox(height: AppSizes.spacingMd),
            Wrap(
              spacing: AppSizes.spacingSm,
              runSpacing: AppSizes.spacingSm,
              children: [
                if (githubUrl != null)
                  _buildLinkButton(tr('projects.github'), githubUrl, Icons.code),
                if (playStoreUrl != null)
                  _buildLinkButton(tr('projects.playStore'), playStoreUrl, Icons.android),
                if (webUrl != null)
                  _buildLinkButton(tr('projects.website'), webUrl, Icons.language),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, String url, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => UrlHelpers.launchURL(url),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.withOpacity(AppColors.primary, 0.2),
        foregroundColor: AppColors.textPrimary,
      ),
    );
  }
}
