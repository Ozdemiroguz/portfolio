import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Project technologies widget
/// Displays project tech stack as chips
class ProjectTechnologiesWidget extends StatelessWidget {
  final List<String> technologies;

  const ProjectTechnologiesWidget({
    super.key,
    required this.technologies,
  });

  @override
  Widget build(BuildContext context) {
    if (technologies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('projects.technologies'),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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
              backgroundColor: AppColors.withOpacity(AppColors.primary, 0.2),
              side: BorderSide(
                color: AppColors.withOpacity(AppColors.primary, 0.4),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

