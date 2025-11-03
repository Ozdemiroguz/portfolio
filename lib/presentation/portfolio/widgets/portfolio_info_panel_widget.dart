import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/download_helpers.dart';
import '../../../core/utils/url_helpers.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../domain/entities/about_data_entity.dart';

/// Portfolio info panel widget
/// Displays welcome message, email link, and CV download on the right side
class PortfolioInfoPanelWidget extends StatelessWidget {
  final List<AppEntity> apps;

  const PortfolioInfoPanelWidget({super.key, required this.apps});

  String? _getEmail() {
    try {
      final contactApp = apps.firstWhere((app) => app.type == 'contact');
      final contactData = contactApp.contactData;
      return contactData?.email;
    } catch (e) {
      // Hata durumunda null döndür
      return null;
    }
  }

  String? _getGitHubUrl() {
    try {
      final contactApp = apps.firstWhere((app) => app.type == 'contact');
      final contactData = contactApp.contactData;
      if (contactData != null) {
        for (var social in contactData.socials) {
          if (social.platform.toLowerCase().contains('github')) {
            return social.url;
          }
        }
      }
    } catch (e) {
      // Hata durumunda null döndür
    }
    return null;
  }

  String? _getLinkedInUrl() {
    try {
      final contactApp = apps.firstWhere((app) => app.type == 'contact');
      final contactData = contactApp.contactData;
      if (contactData != null) {
        for (var social in contactData.socials) {
          if (social.platform.toLowerCase().contains('linkedin')) {
            return social.url;
          }
        }
      }
    } catch (e) {
      // Hata durumunda null döndür
    }
    return null;
  }

  String? _getCvUrl() {
    try {
      final cvApp = apps.firstWhere(
        (app) => app.type == 'cv',
        orElse: () => apps.first,
      );
      if (cvApp.data != null && cvApp.data is Map<String, dynamic>) {
        final data = cvApp.data as Map<String, dynamic>;
        return data['pdfUrl'] as String?;
      }
    } catch (e) {
      // Hata durumunda null döndür
    }
    return null;
  }

  AboutDataEntity? _getAboutData() {
    try {
      final aboutApp = apps.firstWhere((app) => app.type == 'about');
      return aboutApp.aboutData;
    } catch (e) {
      return null;
    }
  }

  Future<void> _launchEmail(String email) async {
    await UrlHelpers.launchEmail(email);
  }

  Future<void> _launchUrl(String url) async {
    await UrlHelpers.launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    final email = _getEmail();
    final cvUrl = _getCvUrl();
    final githubUrl = _getGitHubUrl();
    final linkedinUrl = _getLinkedInUrl();
    final aboutData = _getAboutData();

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.03),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.withOpacity(Colors.white, 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section with image
          if (aboutData != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile image - büyütülmüş
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      aboutData.profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.withOpacity(Colors.white, 0.1),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                            size: 60,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMd),
                // Name and title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aboutData.fullName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        aboutData.title,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingMd),
            // Açıklama metni
            Text(
              tr('portfolio.welcomeDescription'),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSizes.spacingLg),
          ] else ...[
            // Fallback welcome message
            Text(
              tr('portfolio.welcome'),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacingXs),
            Text(
              tr('portfolio.welcomeDescription'),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          // Ayırıcı
          Divider(
            color: AppColors.withOpacity(Colors.white, 0.1),
            thickness: 1,
            height: AppSizes.spacingXl,
          ),

          // Action buttons section
          Text(
            tr('portfolio.connectWithMe'),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSizes.spacingMd),

          // Action buttons - yan yana
          Wrap(
            spacing: AppSizes.spacingSm,
            runSpacing: AppSizes.spacingSm,
            children: [
              // GitHub button
              if (githubUrl != null)
                _buildCompactButton(
                  icon: Icons.code,
                  label: tr('portfolio.github'),
                  onTap: () => _launchUrl(githubUrl),
                ),
              // LinkedIn button
              if (linkedinUrl != null)
                _buildCompactButton(
                  icon: Icons.work,
                  label: tr('portfolio.linkedin'),
                  onTap: () => _launchUrl(linkedinUrl),
                ),
              // Email button
              if (email != null)
                _buildCompactButton(
                  icon: Icons.email,
                  label: tr('portfolio.connect'),
                  onTap: () => _launchEmail(email),
                ),
              // CV Download button
              if (cvUrl != null)
                _buildCompactButton(
                  icon: Icons.download,
                  label: tr('portfolio.download'),
                  onTap:
                      () => DownloadHelpers.downloadPdf(
                        cvUrl,
                        fileName: 'Oguzhan-Ozdemir-CV.pdf',
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusXs),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm,
          vertical: AppSizes.paddingXs,
        ),
        decoration: BoxDecoration(
          color: AppColors.withOpacity(Colors.white, 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          border: Border.all(color: AppColors.withOpacity(Colors.white, 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 14),
            const SizedBox(width: AppSizes.spacingXs / 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
