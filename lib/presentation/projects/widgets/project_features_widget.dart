import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/translation_helpers.dart';

/// Project features widget
/// Displays project features as a bullet list
class ProjectFeaturesWidget extends StatelessWidget {
  final List<String> features;
  final List<String>? featuresKeys;

  const ProjectFeaturesWidget({
    super.key,
    required this.features,
    this.featuresKeys,
  });

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('projects.features'),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;

          // Try to get translation key if available
          final featureKey = featuresKeys != null && index < featuresKeys!.length
              ? featuresKeys![index]
              : null;

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
                    TranslationHelpers.tryTranslate(featureKey, feature),
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
    );
  }
}

