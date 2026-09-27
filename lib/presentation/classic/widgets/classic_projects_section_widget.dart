import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/app_entity.dart';
import '../project_showcase.dart';
import 'classic_project_card_widget.dart';
import 'classic_project_detail_dialog.dart';

/// Projects showcase: category filters, then a grid on wide screens or a
/// swipeable carousel on phones so the section stays short.
class ClassicProjectsSectionWidget extends StatefulWidget {
  final List<AppEntity> projectApps;

  const ClassicProjectsSectionWidget({super.key, required this.projectApps});

  @override
  State<ClassicProjectsSectionWidget> createState() =>
      _ClassicProjectsSectionWidgetState();
}

class _ClassicProjectsSectionWidgetState
    extends State<ClassicProjectsSectionWidget> {
  /// Cards shown in the grid before the "show all" button.
  static const _initialGridCount = 9;

  ProjectCategory _category = ProjectCategory.all;
  bool _expanded = false;
  late List<ProjectShowcaseItem> _all = buildProjectShowcase(widget.projectApps);

  @override
  void didUpdateWidget(covariant ClassicProjectsSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectApps != widget.projectApps) {
      _all = buildProjectShowcase(widget.projectApps);
    }
  }

  List<ProjectShowcaseItem> get _visible =>
      _all.where((item) => item.matches(_category)).toList();

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterBar(
          selected: _category,
          counts: {
            for (final category in ProjectCategory.values)
              category: _all.where((item) => item.matches(category)).length,
          },
          onSelected: (category) => setState(() {
            _category = category;
            _expanded = false;
          }),
        ),
        const SizedBox(height: AppSizes.spacingLg),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width < 600) {
              return _Carousel(
                key: ValueKey(_category),
                items: visible,
                width: width,
              );
            }
            final columns = width >= 900 ? 3 : 2;
            const gap = AppSizes.spacingLg;
            final cardWidth = (width - gap * (columns - 1)) / columns;
            final shown = _expanded
                ? visible
                : visible.take(_initialGridCount).toList();
            final hidden = visible.length - shown.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final item in shown)
                      SizedBox(
                        width: cardWidth,
                        child: ClassicProjectCardWidget(
                          item: item,
                          onTap: () =>
                              showClassicProjectDetail(context, item.app),
                        ),
                      ),
                  ],
                ),
                if (hidden > 0 || _expanded) ...[
                  const SizedBox(height: AppSizes.spacingLg),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _expanded = !_expanded),
                      icon: Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: AppSizes.iconXs,
                      ),
                      label: Text(
                        _expanded
                            ? tr('classic.projects.showLess')
                            : tr(
                                'classic.projects.showMore',
                                namedArgs: {'count': '$hidden'},
                              ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(
                          color: AppColors.withOpacity(Colors.white, 0.25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingLg,
                          vertical: AppSizes.paddingMd,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final ProjectCategory selected;
  final Map<ProjectCategory, int> counts;
  final ValueChanged<ProjectCategory> onSelected;

  const _FilterBar({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  static String _label(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.all:
        return tr('classic.projects.filterAll');
      case ProjectCategory.published:
        return tr('classic.projects.filterPublished');
      case ProjectCategory.openSource:
        return tr('classic.projects.filterOpenSource');
      case ProjectCategory.work:
        return tr('classic.projects.filterWork');
    }
  }

  static IconData _icon(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.all:
        return Icons.grid_view;
      case ProjectCategory.published:
        return Icons.storefront;
      case ProjectCategory.openSource:
        return Icons.code;
      case ProjectCategory.work:
        return Icons.business_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in ProjectCategory.values)
            if ((counts[category] ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.only(right: AppSizes.spacingSm),
                child: _FilterChip(
                  icon: _icon(category),
                  label: _label(category),
                  count: counts[category] ?? 0,
                  selected: category == selected,
                  onTap: () => onSelected(category),
                ),
              ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : AppColors.textSecondary;
    return Material(
      color: selected ? AppColors.primary : AppColors.withOpacity(Colors.white, 0.06),
      borderRadius: BorderRadius.circular(AppSizes.radiusRound),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMd,
            vertical: AppSizes.paddingSm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusRound),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.withOpacity(Colors.white, 0.12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSizes.iconXs, color: foreground),
              const SizedBox(width: AppSizes.spacingXs),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSizes.spacingXs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(Colors.black, selected ? 0.25 : 0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusRound),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(color: foreground, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Phone layout: one card at a time, swipe for the next, with dots.
class _Carousel extends StatefulWidget {
  final List<ProjectShowcaseItem> items;
  final double width;

  const _Carousel({super.key, required this.items, required this.width});

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  late final PageController _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    // Visual header + text block. The card clips anything beyond this, so
    // taller content degrades gracefully instead of overflowing.
    const cardHeight = 440.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (index) => setState(() => _page = index),
            padEnds: false,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: AppSizes.spacingMd),
                child: ClassicProjectCardWidget(
                  item: item,
                  onTap: () => showClassicProjectDetail(context, item.app),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.spacingMd),
        Row(
          children: [
            // Dots for short lists; a slim progress bar once they would
            // no longer fit on a phone.
            if (items.length <= 8)
              for (var i = 0; i < items.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 6),
                  width: i == _page ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? AppColors.primary
                        : AppColors.withOpacity(Colors.white, 0.25),
                    borderRadius: BorderRadius.circular(AppSizes.radiusRound),
                  ),
                )
            else
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusRound),
                  child: LinearProgressIndicator(
                    value: (_page + 1) / items.length,
                    minHeight: 6,
                    backgroundColor: AppColors.withOpacity(Colors.white, 0.15),
                    color: AppColors.primary,
                  ),
                ),
              ),
            if (items.length <= 8) const Spacer() else const SizedBox(width: AppSizes.spacingMd),
            Text(
              '${_page + 1} / ${items.length}  ·  ${tr('classic.projects.swipeHint')}',
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
