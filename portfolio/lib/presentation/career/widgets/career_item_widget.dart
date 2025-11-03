import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/career_data_entity.dart';

/// Career item widget
/// Displays a single work experience
class CareerItemWidget extends StatelessWidget {
  final ExperienceEntity experience;
  final bool isLast;

  const CareerItemWidget({
    super.key,
    required this.experience,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final duration = _calculateDuration(experience.startDate, experience.endDate);

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
          // Position
          Text(
            experience.position,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacingXs),

          // Company
          Text(
            experience.company,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spacingXs),

          // Duration
          if (duration != null)
            Text(
              duration,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),

          // Description
          if (experience.description.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              experience.description,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],

          // Technologies
          if (experience.technologies.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMd),
            Wrap(
              spacing: AppSizes.spacingSm,
              runSpacing: AppSizes.spacingSm,
              children: experience.technologies.map((tech) {
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
        ],
      ),
    );
  }

  String? _calculateDuration(dynamic startDate, dynamic endDate) {
    try {
      final start = DateHelpers.parseDateTime(startDate);
      final end = endDate != null
          ? DateHelpers.parseDateTime(endDate)
          : DateTime.now();

      return DateHelpers.calculateDuration(start, end);
    } catch (e) {
      return null;
    }
  }
}
