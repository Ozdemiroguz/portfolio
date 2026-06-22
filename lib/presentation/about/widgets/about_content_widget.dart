import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
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

          const SizedBox(height: AppSizes.spacingMd),

          // CTA buttons — App Store + GitHub
          Row(
            children: [
              Expanded(
                child: _CtaButton(
                  icon: Icons.apple,
                  label: tr('about.viewAppStore'),
                  color: const Color(0xFF0A84FF),
                  onTap: () => _launchUrl(
                    'https://apps.apple.com/us/developer/oguzhan-0zdemir/id1780829933',
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              Expanded(
                child: _CtaButton(
                  icon: Icons.code_rounded,
                  label: tr('about.viewGitHub'),
                  color: const Color(0xFF6E5494),
                  onTap: () => _launchUrl('https://github.com/Ozdemiroguz'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 100), // Bottom spacing
        ],
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _CtaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CtaButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.paddingMd,
            horizontal: AppSizes.paddingMd,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.78)],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: AppSizes.spacingXs),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
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
