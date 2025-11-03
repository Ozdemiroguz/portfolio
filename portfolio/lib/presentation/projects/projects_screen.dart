import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

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

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),

          // Image Carousel (if images exist)
          if (project.images.isNotEmpty) ...[
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 0.9,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: project.images.map((imagePath) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 250, // Carousel yüksekliği ile uyumlu
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.fitHeight, // Dikey olarak tam oturması için
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  project.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Date
                Text(
                  _formatDate(project.startDate, project.endDate),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),

                // Client/Owner Info
                Row(
                  children: [
                    Icon(
                      project.ownProject ? Icons.person : Icons.business,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      project.ownProject
                          ? tr('projects.personalProject')
                          : (project.clientName ?? tr('projects.clientProject')),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Role
                if (project.role != null && project.role!.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.badge,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        project.role!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Description
                if (project.description.isNotEmpty)
                  Text(
                    project.description,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                const SizedBox(height: 25),

                // Link Buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildLinkButton(
                      tr('projects.github'),
                      Icons.code,
                      project.githubUrl,
                    ),
                    _buildLinkButton(
                      tr('projects.playStore'),
                      Icons.android,
                      project.playStoreUrl,
                    ),
                    _buildLinkButton(
                      tr('projects.appStore'),
                      Icons.apple,
                      project.appStoreUrl,
                    ),
                    _buildLinkButton(
                      tr('projects.linkedin'),
                      Icons.work,
                      project.linkedinUrl,
                    ),
                    if (project.webUrl != null)
                      _buildLinkButton(
                        tr('projects.website'),
                        Icons.language,
                        project.webUrl,
                      ),
                  ],
                ),

                const SizedBox(height: 30),

                // Technologies
                if (project.technologies.isNotEmpty) ...[
                  Text(
                    tr('projects.technologies'),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: AppSizes.spacingSm,
                    runSpacing: AppSizes.spacingSm,
                    children: project.technologies.map((tech) {
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
                  const SizedBox(height: 25),
                ],

                // Features
                if (project.features.isNotEmpty) ...[
                  Text(
                    tr('projects.features'),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...project.features.map((feature) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

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

  Widget _buildLinkButton(String label, IconData icon, String? url) {
    final bool isActive = url != null && url.isNotEmpty;

    return ElevatedButton.icon(
      onPressed: isActive ? () => _launchUrl(url) : null,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive
            ? AppColors.withOpacity(AppColors.primary, 0.2)
            : AppColors.withOpacity(Colors.grey, 0.1),
        foregroundColor: isActive ? AppColors.textPrimary : AppColors.textSecondary,
        disabledBackgroundColor: AppColors.withOpacity(Colors.grey, 0.1),
        disabledForegroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
