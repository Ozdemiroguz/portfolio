import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/translation_helpers.dart';
import '../../../domain/entities/app_entity.dart';

/// Compact project card for the classic projects grid.
class ClassicProjectCardWidget extends StatefulWidget {
  final AppEntity app;
  final VoidCallback onTap;

  const ClassicProjectCardWidget({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  State<ClassicProjectCardWidget> createState() =>
      _ClassicProjectCardWidgetState();
}

class _ClassicProjectCardWidgetState extends State<ClassicProjectCardWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.app.projectData?.projects.firstOrNull;
    final title = project == null
        ? TranslationHelpers.tryTranslate(widget.app.titleKey, widget.app.title)
        : TranslationHelpers.tryTranslate(project.titleKey, project.title);
    final description = project == null
        ? TranslationHelpers.tryTranslate(
            widget.app.descriptionKey, widget.app.description)
        : TranslationHelpers.tryTranslate(
            project.descriptionKey, project.description);
    final technologies = project?.technologies ?? const <String>[];
    final image = project?.images.firstOrNull ??
        widget.app.images.firstOrNull ??
        widget.app.iconImage;

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
            color: AppColors.withOpacity(Colors.white, _hovered ? 0.08 : 0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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
            children: [
              _Cover(image: image, emoji: widget.app.icon),
              Padding(
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingSm),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    if (technologies.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.spacingMd),
                      Wrap(
                        spacing: AppSizes.spacingXs,
                        runSpacing: AppSizes.spacingXs,
                        children: [
                          for (final tech in technologies.take(4))
                            _TechChip(label: tech),
                          if (technologies.length > 4)
                            _TechChip(label: '+${technologies.length - 4}'),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSizes.spacingMd),
                    Row(
                      children: [
                        Text(
                          tr('classic.viewDetails'),
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacingXs),
                        const Icon(
                          Icons.arrow_forward,
                          size: AppSizes.iconXs,
                          color: AppColors.primaryLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String? image;
  final String emoji;

  const _Cover({required this.image, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: AppColors.withOpacity(AppColors.backgroundDark3, 0.6),
        child: image == null
            ? Center(child: Text(emoji, style: const TextStyle(fontSize: 48)))
            : Image.asset(
                image!,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, _, _) => Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 48)),
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
