import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/translation_helpers.dart';
import '../../../core/utils/url_helpers.dart';
import '../project_showcase.dart';
import 'classic_project_visual_widget.dart';

/// Showcase card: logo + phone-framed screenshot, store badges and the
/// essentials. Tapping the card opens the full detail view.
class ClassicProjectCardWidget extends StatefulWidget {
  final ProjectShowcaseItem item;
  final VoidCallback onTap;

  const ClassicProjectCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<ClassicProjectCardWidget> createState() =>
      _ClassicProjectCardWidgetState();
}

class _ClassicProjectCardWidgetState extends State<ClassicProjectCardWidget> {
  bool _hovered = false;

  ProjectShowcaseItem get item => widget.item;

  @override
  Widget build(BuildContext context) {
    final project = item.project;
    final title = TranslationHelpers.tryTranslate(project.titleKey, project.title);
    final description = TranslationHelpers.tryTranslate(
      project.descriptionKey,
      project.description,
    );
    final technologies = project.technologies;

    return LayoutBuilder(
      builder: (context, constraints) {
        // In the phone carousel the card gets a fixed height; keep the text
        // block from overflowing by letting it fill and clip instead.
        final bounded = constraints.hasBoundedHeight;
        final compact = constraints.maxWidth < 340;
        final body = Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                _meta(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: AppSizes.spacingSm),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSizes.spacingMd),
              _LinkBadges(item: item, compact: compact),
              if (technologies.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spacingMd),
                Wrap(
                  spacing: AppSizes.spacingXs,
                  runSpacing: AppSizes.spacingXs,
                  children: [
                    for (final tech in technologies.take(3))
                      _TechChip(label: tech),
                    if (technologies.length > 3)
                      _TechChip(label: '+${technologies.length - 3}'),
                  ],
                ),
              ],
            ],
          ),
        );

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
              decoration: BoxDecoration(
                color: AppColors.withOpacity(Colors.white, _hovered ? 0.07 : 0.04),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                border: Border.all(
                  color: _hovered
                      ? AppColors.withOpacity(AppColors.primary, 0.6)
                      : AppColors.withOpacity(Colors.white, 0.1),
                ),
                boxShadow: [
                  if (_hovered)
                    BoxShadow(
                      color: AppColors.withOpacity(Colors.black, 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ClassicProjectVisualWidget(
                        images: project.images,
                        iconImage: item.app.iconImage,
                        emoji: item.app.icon,
                        height: compact ? 190 : 210,
                      ),
                      Positioned(
                        top: AppSizes.paddingMd,
                        right: AppSizes.paddingMd,
                        child: _StatusTag(item: item),
                      ),
                    ],
                  ),
                  if (bounded)
                    // A non-scrolling scroll view gives the text block
                    // unbounded height, so it clips instead of overflowing.
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: body,
                      ),
                    )
                  else
                    body,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _meta() {
    final project = item.project;
    final parts = <String>[];
    final client = project.clientName;
    if (client != null && client.isNotEmpty) {
      parts.add(TranslationHelpers.tryTranslate(project.clientNameKey, client));
    } else if (project.ownProject) {
      parts.add(tr('projects.personalProject'));
    }
    final team = project.teamSize;
    if (team != null && team > 1) {
      parts.add(tr('classic.projects.teamOf', namedArgs: {'count': '$team'}));
    }
    final year = project.startDate.length >= 4
        ? project.startDate.substring(0, 4)
        : project.startDate;
    if (year.isNotEmpty) parts.add(year);
    return parts.join('  ·  ');
  }
}

/// Small coloured tag in the visual's corner summarising the project state.
class _StatusTag extends StatelessWidget {
  final ProjectShowcaseItem item;

  const _StatusTag({required this.item});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;
    final IconData icon;

    if (item.isPublished && item.project.status == 'in_testing') {
      label = tr('classic.projects.inTesting');
      color = AppColors.warning;
      icon = Icons.science;
    } else if (item.isPublished) {
      label = tr('classic.projects.liveOnStores');
      color = AppColors.success;
      icon = Icons.rocket_launch;
    } else if (item.project.status == 'in_progress') {
      label = tr('classic.projects.inProgress');
      color = AppColors.warning;
      icon = Icons.autorenew;
    } else if (item.isOpenSource) {
      label = tr('classic.projects.openSource');
      color = AppColors.primaryLight;
      icon = Icons.code;
    } else {
      label = tr('classic.projects.caseStudy');
      color = AppColors.textSecondary;
      icon = Icons.article;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.backgroundDark1, 0.85),
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
        border: Border.all(color: AppColors.withOpacity(color, 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: AppSizes.spacingXs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Direct links to the stores, source and demos. These open the URL and do
/// not trigger the card's own tap.
class _LinkBadges extends StatelessWidget {
  final ProjectShowcaseItem item;

  /// Icon-only badges for narrow cards.
  final bool compact;

  const _LinkBadges({required this.item, required this.compact});

  @override
  Widget build(BuildContext context) {
    final project = item.project;
    final badges = <_BadgeData>[
      if (item.onAppStore)
        _BadgeData(Icons.apple, tr('projects.appStore'), project.appStoreUrl!),
      if (item.onPlayStore)
        _BadgeData(Icons.android, tr('projects.playStore'), project.playStoreUrl!),
      if (item.isOpenSource)
        _BadgeData(Icons.code, tr('projects.github'), project.githubUrl!),
      if (item.hasWebsite)
        _BadgeData(Icons.language, tr('projects.website'), project.webUrl!),
      if (item.hasDemo)
        _BadgeData(
          item.demoIsApk ? Icons.download : Icons.play_circle_outline,
          item.demoIsApk ? tr('classic.projects.apk') : tr('projects.viewDemo'),
          project.demoUrl!,
        ),
    ];

    if (badges.isEmpty) {
      return Text(
        tr('classic.projects.privateBuild'),
        style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
      );
    }

    return Wrap(
      spacing: AppSizes.spacingSm,
      runSpacing: AppSizes.spacingSm,
      children: [
        for (final badge in badges)
          _Badge(
            icon: badge.icon,
            label: badge.label,
            url: badge.url,
            compact: compact,
          ),
      ],
    );
  }
}

class _BadgeData {
  final IconData icon;
  final String label;
  final String url;

  const _BadgeData(this.icon, this.label, this.url);
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool compact;

  const _Badge({
    required this.icon,
    required this.label,
    required this.url,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final content = compact
        ? Icon(icon, size: 18, color: AppColors.textPrimary)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSizes.iconXs, color: AppColors.textPrimary),
              const SizedBox(width: AppSizes.spacingXs),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return Tooltip(
      message: label,
      child: Material(
        color: AppColors.withOpacity(Colors.white, 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
        child: InkWell(
          onTap: () => UrlHelpers.launchURL(url),
          borderRadius: BorderRadius.circular(AppSizes.radiusRound),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSizes.paddingSm + 2 : AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.primary, 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
        border: Border.all(color: AppColors.withOpacity(AppColors.primary, 0.35)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
      ),
    );
  }
}
