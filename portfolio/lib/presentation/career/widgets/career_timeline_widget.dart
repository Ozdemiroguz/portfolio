import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/career_data_entity.dart';
import 'career_item_widget.dart';

/// Career timeline widget
/// Displays list of work experiences
class CareerTimelineWidget extends StatelessWidget {
  final CareerDataEntity data;

  const CareerTimelineWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final experiences = data.experiences;

    if (experiences.isEmpty) {
      return Center(
        child: Text(
          tr('career.noData'),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingLg),
          child: CareerItemWidget(
            experience: experience,
            isLast: index == experiences.length - 1,
          ),
        );
      }).toList(),
    );
  }
}
