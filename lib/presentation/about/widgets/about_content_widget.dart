import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/about_data_entity.dart';
import 'about_data_card_widget.dart';

/// About content widget
/// Displays all about data in cards
class AboutContentWidget extends StatelessWidget {
  final AboutDataEntity data;

  const AboutContentWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Build list of data entries
    final List<_DataEntry> entries = [
      if (data.fullName.isNotEmpty)
        _DataEntry(
          labelKey: 'about.fullName',
          value: data.fullName,
          valueKey: data.fullNameKey,
        ),
      if (data.title.isNotEmpty)
        _DataEntry(
          labelKey: 'about.jobTitle',
          value: data.title,
          valueKey: data.titleKey,
        ),
      if (data.bio.isNotEmpty)
        _DataEntry(
          labelKey: 'about.bio',
          value: data.bio,
          valueKey: data.bioKey,
        ),
      if (data.location.isNotEmpty)
        _DataEntry(
          labelKey: 'about.location',
          value: data.location,
          valueKey: data.locationKey,
        ),
      if (data.birthDate.isNotEmpty)
        _DataEntry(
          labelKey: 'about.birthDate',
          value: data.birthDate,
          valueKey: data.birthDateKey,
        ),
      if (data.education.isNotEmpty)
        _DataEntry(
          labelKey: 'about.education',
          value: data.education,
          valueKey: data.educationKey,
        ),
      if (data.interests.isNotEmpty)
        _DataEntry(
          labelKey: 'about.interests',
          value: data.interests,
          valueKeys: data.interestsKeys,
        ),
    ];

    if (entries.isEmpty) {
      return Center(
        child: Text(
          tr('about.noDataAvailable'),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ...entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
              child: AboutDataCardWidget(
                fieldKey: entry.labelKey,
                value: entry.value,
                valueKey: entry.valueKey,
                valueKeys: entry.valueKeys,
              ),
            );
          }),
          const SizedBox(height: 100), // Bottom spacing
        ],
      ),
    );
  }
}

/// Helper class to hold data entries
class _DataEntry {
  final String labelKey;
  final Object value;
  final String? valueKey;
  final List<String>? valueKeys;

  _DataEntry({
    required this.labelKey,
    required this.value,
    this.valueKey,
    this.valueKeys,
  });
}
