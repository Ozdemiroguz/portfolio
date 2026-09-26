import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/download_helpers.dart';
import '../../../core/utils/translation_helpers.dart';
import '../../../core/utils/url_helpers.dart';
import '../classic_apps.dart';
import 'classic_section_widget.dart';

/// Introduction block: photo, name, title, bio and the primary actions.
class ClassicHeroWidget extends StatelessWidget {
  final ClassicApps apps;
  final VoidCallback onViewProjects;

  const ClassicHeroWidget({
    super.key,
    required this.apps,
    required this.onViewProjects,
  });

  @override
  Widget build(BuildContext context) {
    final about = apps.about;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: ClassicSectionWidget.maxContentWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLg,
            vertical: AppSizes.spacingXxl,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 760;
              final photo = _Photo(imageUrl: about?.profileImage);
              final text = _IntroText(
                apps: apps,
                centered: stacked,
                onViewProjects: onViewProjects,
              );

              if (stacked) {
                return Column(
                  children: [
                    photo,
                    const SizedBox(height: AppSizes.spacingXl),
                    text,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 3, child: text),
                  const SizedBox(width: AppSizes.spacingXxl),
                  Expanded(flex: 2, child: Center(child: photo)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  final String? imageUrl;

  const _Photo({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(AppColors.primary, 0.35),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl == null
            ? const _PhotoFallback()
            : Image.asset(
                imageUrl!,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, _, _) => const _PhotoFallback(),
              ),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.withOpacity(Colors.white, 0.1),
      child: const Icon(
        Icons.person,
        color: AppColors.textSecondary,
        size: AppSizes.iconXxl,
      ),
    );
  }
}

class _IntroText extends StatelessWidget {
  final ClassicApps apps;
  final bool centered;
  final VoidCallback onViewProjects;

  const _IntroText({
    required this.apps,
    required this.centered,
    required this.onViewProjects,
  });

  @override
  Widget build(BuildContext context) {
    final about = apps.about;
    final name = about == null
        ? tr('portfolio.welcome')
        : TranslationHelpers.tryTranslate(about.fullNameKey, about.fullName);
    final title = about == null
        ? ''
        : TranslationHelpers.tryTranslate(about.titleKey, about.title);
    final bio = about == null
        ? tr('portfolio.welcomeDescription')
        : TranslationHelpers.tryTranslate(about.bioKey, about.bio);
    final location = about == null
        ? ''
        : TranslationHelpers.tryTranslate(about.locationKey, about.location);

    final align = centered ? TextAlign.center : TextAlign.start;
    final cross = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final email = apps.contact?.email;
    final cvUrl = apps.cvUrl;
    final github = apps.socialUrl('github');
    final linkedin = apps.socialUrl('linkedin');

    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          tr('classic.greeting'),
          textAlign: align,
          style: const TextStyle(
            color: AppColors.primaryLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSm),
        Text(
          name,
          textAlign: align,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 44,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        if (title.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacingSm),
          Text(
            title,
            textAlign: align,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (location.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacingSm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                size: AppSizes.iconXs,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSizes.spacingXs),
              Text(
                location,
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSizes.spacingLg),
        Text(
          bio,
          textAlign: align,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.7,
          ),
        ),
        const SizedBox(height: AppSizes.spacingXl),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: AppSizes.spacingSm,
          runSpacing: AppSizes.spacingSm,
          children: [
            FilledButton.icon(
              onPressed: onViewProjects,
              icon: const Icon(Icons.grid_view, size: AppSizes.iconXs),
              label: Text(tr('classic.viewProjects')),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLg,
                  vertical: AppSizes.paddingMd,
                ),
              ),
            ),
            if (cvUrl != null)
              _SecondaryButton(
                icon: Icons.download,
                label: tr('portfolio.downloadCV'),
                onTap: () => DownloadHelpers.downloadPdf(
                  cvUrl,
                  fileName: 'Oguzhan-Ozdemir-CV.pdf',
                ),
              ),
            if (email != null && email.isNotEmpty)
              _SecondaryButton(
                icon: Icons.email,
                label: tr('portfolio.connect'),
                onTap: () => UrlHelpers.launchEmail(email),
              ),
            if (github != null)
              _SecondaryButton(
                icon: Icons.code,
                label: tr('portfolio.github'),
                onTap: () => UrlHelpers.launchURL(github),
              ),
            if (linkedin != null)
              _SecondaryButton(
                icon: Icons.work,
                label: tr('portfolio.linkedin'),
                onTap: () => UrlHelpers.launchURL(linkedin),
              ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: AppSizes.iconXs),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(color: AppColors.withOpacity(Colors.white, 0.25)),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLg,
          vertical: AppSizes.paddingMd,
        ),
      ),
    );
  }
}
