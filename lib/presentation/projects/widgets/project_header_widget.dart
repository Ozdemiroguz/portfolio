import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';

/// Project header widget
/// Displays title, date, client, and role information
class ProjectHeaderWidget extends StatelessWidget {
  final String title;
  final String dateRange;
  final bool ownProject;
  final String? clientName;
  final String? role;

  const ProjectHeaderWidget({
    super.key,
    required this.title,
    required this.dateRange,
    required this.ownProject,
    this.clientName,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Date
        Text(
          dateRange,
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
              ownProject ? Icons.person : Icons.business,
              color: AppColors.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              ownProject
                  ? tr('projects.personalProject')
                  : (clientName ?? tr('projects.clientProject')),
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
        if (role != null && role!.isNotEmpty)
          Row(
            children: [
              const Icon(
                Icons.badge,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                role!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}

