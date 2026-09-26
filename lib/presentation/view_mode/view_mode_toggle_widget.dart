import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'view_mode_cubit.dart';

/// Segmented pill that switches between the phone and classic layouts.
class ViewModeToggleWidget extends StatelessWidget {
  final ViewMode current;

  /// Icons only, for tight spaces such as a phone-width nav bar.
  final bool compact;

  const ViewModeToggleWidget({
    super.key,
    required this.current,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.black, 0.35),
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            icon: Icons.phone_iphone,
            label: tr('viewMode.phone'),
            selected: current == ViewMode.phone,
            compact: compact,
            onTap: () => context.read<ViewModeCubit>().select(ViewMode.phone),
          ),
          _Segment(
            icon: Icons.web,
            label: tr('viewMode.classic'),
            selected: current == ViewMode.classic,
            compact: compact,
            onTap: () => context.read<ViewModeCubit>().select(ViewMode.classic),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _Segment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSizes.paddingSm : AppSizes.paddingMd,
            vertical: AppSizes.paddingSm,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusRound),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppSizes.iconXs,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              if (!compact) ...[
                const SizedBox(width: AppSizes.spacingXs),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
