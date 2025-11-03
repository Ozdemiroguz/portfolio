import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/contact_data_entity.dart';

/// Contact social links widget
/// Displays social media links as individual clickable cards
class ContactSocialLinksWidget extends StatelessWidget {
  final ContactDataEntity data;

  const ContactSocialLinksWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final socials = data.socials;

    if (socials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('contact.socialMedia'),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacingMd),

          // Display each social link as a separate card
          ...socials.map((social) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingSm),
              child: _buildSocialCard(social.platform, social.url),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSocialCard(String platform, String url) {
    final icon = _getPlatformIcon(platform);
    final color = _getPlatformColor(platform);
    final isMedium = platform.toLowerCase().contains('medium');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          decoration: BoxDecoration(
            color: AppColors.withOpacity(color, 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: AppColors.withOpacity(color, 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(color, 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSizes.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (isMedium)
                      Text(
                        tr('contact.medium.articles'),
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Text(
                        url,
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    final lowerPlatform = platform.toLowerCase();
    if (lowerPlatform.contains('github')) {
      return Icons.code;
    } else if (lowerPlatform.contains('linkedin')) {
      return Icons.business;
    } else if (lowerPlatform.contains('twitter')) {
      return Icons.alternate_email;
    } else if (lowerPlatform.contains('instagram')) {
      return Icons.camera_alt;
    } else if (lowerPlatform.contains('youtube')) {
      return Icons.play_circle;
    } else if (lowerPlatform.contains('medium')) {
      return Icons.article;
    } else {
      return Icons.link;
    }
  }

  Color _getPlatformColor(String platform) {
    // Tüm linkler aynı renkte olsun
    return AppColors.primary;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
