import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../view_mode/view_mode_cubit.dart';
import '../../view_mode/view_mode_toggle_widget.dart';
import 'classic_section_widget.dart';

/// A navigation entry: label plus the callback that scrolls to its section.
class ClassicNavItem {
  final String label;
  final VoidCallback onTap;

  const ClassicNavItem({required this.label, required this.onTap});
}

/// Sticky top bar with section links, language switch and view mode toggle.
class ClassicNavBarWidget extends StatelessWidget {
  static const double height = 64;

  /// Below this width the section links collapse into a menu.
  static const double collapseBreakpoint = 960;

  final String brand;
  final List<ClassicNavItem> items;

  const ClassicNavBarWidget({
    super.key,
    required this.brand,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.backgroundDark1, 0.95),
        border: Border(
          bottom: BorderSide(color: AppColors.withOpacity(Colors.white, 0.08)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ClassicSectionWidget.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.maxWidth < collapseBreakpoint;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        brand,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!collapsed)
                      for (final item in items) _NavLink(item: item),
                    const SizedBox(width: AppSizes.spacingSm),
                    _LanguageButton(compact: collapsed),
                    const SizedBox(width: AppSizes.spacingSm),
                    ViewModeToggleWidget(
                      current: ViewMode.classic,
                      compact: collapsed,
                    ),
                    if (collapsed) ...[
                      const SizedBox(width: AppSizes.spacingXs),
                      PopupMenuButton<ClassicNavItem>(
                        tooltip: tr('classic.menu'),
                        icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                        color: AppColors.backgroundDark2,
                        onSelected: (item) => item.onTap(),
                        itemBuilder: (context) => [
                          for (final item in items)
                            PopupMenuItem(
                              value: item,
                              child: Text(
                                item.label,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final ClassicNavItem item;

  const _NavLink({required this.item});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: item.onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      ),
      child: Text(
        item.label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// Switches between the supported locales.
class _LanguageButton extends StatelessWidget {
  final bool compact;

  const _LanguageButton({required this.compact});

  @override
  Widget build(BuildContext context) {
    final isTurkish = context.locale.languageCode == 'tr';
    final next = isTurkish ? const Locale('en') : const Locale('tr');
    final style = OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      side: BorderSide(color: AppColors.withOpacity(Colors.white, 0.2)),
      minimumSize: Size.zero,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSizes.paddingSm : AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );
    final label = Text(next.languageCode.toUpperCase());

    return Tooltip(
      message: tr('app.changeLanguage'),
      child: compact
          ? OutlinedButton(
              onPressed: () => context.setLocale(next),
              style: style,
              child: label,
            )
          : OutlinedButton.icon(
              onPressed: () => context.setLocale(next),
              icon: const Icon(Icons.language, size: AppSizes.iconXs),
              label: label,
              style: style,
            ),
    );
  }
}
