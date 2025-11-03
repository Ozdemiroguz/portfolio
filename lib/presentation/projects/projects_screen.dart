import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/translation_helpers.dart';
import 'widgets/project_image_carousel_widget.dart';
import 'widgets/project_header_widget.dart';
import 'widgets/project_technologies_widget.dart';
import 'widgets/project_features_widget.dart';
import 'widgets/project_links_widget.dart';

/// Projects screen
/// Displays single project details
class ProjectsScreen extends StatelessWidget {
  final AppEntity app;

  const ProjectsScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    final projectData = app.projectData;

    if (projectData == null || projectData.projects.isEmpty) {
      return Center(
        child: Text(tr('projects.noData')),
      );
    }

    // Get first project (since each app now has only one project)
    final project = projectData.projects.first;
    
    // Get translated values using helper
    final title = TranslationHelpers.tryTranslate(project.titleKey, project.title);
    final description = TranslationHelpers.tryTranslate(project.descriptionKey, project.description);
    final role = project.roleKey != null && project.role != null
        ? TranslationHelpers.tryTranslate(project.roleKey, project.role!)
        : project.role;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel
          ProjectImageCarouselWidget(images: project.images),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Title, Date, Client, Role)
                ProjectHeaderWidget(
                  title: title,
                  dateRange: _formatDate(project.startDate, project.endDate),
                  ownProject: project.ownProject,
                  clientName: project.clientName,
                  role: role,
                ),

                // Description
                if (description.isNotEmpty) ...[
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 25),
                ],

                // Links
                ProjectLinksWidget(
                  githubUrl: project.githubUrl,
                  playStoreUrl: project.playStoreUrl,
                  appStoreUrl: project.appStoreUrl,
                  linkedinUrl: project.linkedinUrl,
                  webUrl: project.webUrl,
                ),

                // Technologies
                ProjectTechnologiesWidget(
                  technologies: project.technologies,
                ),

                // Features
                ProjectFeaturesWidget(
                  features: project.features,
                  featuresKeys: project.featuresKeys,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? startDate, String? endDate) {
    if (startDate == null) return '';

    final start = startDate;
    final end = endDate ?? tr('projects.present');

    return '$start - $end';
  }
}
