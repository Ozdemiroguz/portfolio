import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../view_mode/view_mode_cubit.dart';
import 'classic_section_widget.dart';

/// Closing block that invites the visitor into the interactive phone mode.
class ClassicFooterWidget extends StatelessWidget {
  final String ownerName;

  const ClassicFooterWidget({super.key, required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.black, 0.25),
        border: Border(
          top: BorderSide(color: AppColors.withOpacity(Colors.white, 0.08)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ClassicSectionWidget.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.spacingXxl,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.phone_iphone,
                  color: AppColors.primaryLight,
                  size: AppSizes.iconLg,
                ),
                const SizedBox(height: AppSizes.spacingMd),
                Text(
                  tr('classic.tryInteractive'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingSm),
                Text(
                  tr('classic.tryInteractiveDescription'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingLg),
                FilledButton.icon(
                  onPressed: () =>
                      context.read<ViewModeCubit>().select(ViewMode.phone),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(tr('classic.openPhoneMode')),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                      vertical: AppSizes.paddingMd,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingXxl),
                Text(
                  '© ${DateTime.now().year} $ownerName',
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
