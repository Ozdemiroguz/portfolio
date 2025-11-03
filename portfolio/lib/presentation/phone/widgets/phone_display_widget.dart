import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';

/// Phone display widget
class PhoneDisplayWidget extends StatelessWidget {
  final String dialedNumber;
  final String status;

  const PhoneDisplayWidget({
    super.key,
    required this.dialedNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display number
          Text(
            dialedNumber.isEmpty 
                ? tr('phone.display.enterNumber')
                : _formatNumber(dialedNumber),
            style: TextStyle(
              color: dialedNumber.isEmpty
                  ? AppColors.textSecondary.withValues(alpha: 0.5)
                  : AppColors.textPrimary,
              fontSize: dialedNumber.isEmpty ? 20 : 36,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Status text
          if (status.isNotEmpty)
            Text(
              status,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  String _formatNumber(String number) {
    // Format number for better readability
    if (number.length <= 3) return number;
    if (number.length <= 6) {
      return '${number.substring(0, 3)} ${number.substring(3)}';
    }
    if (number.length <= 10) {
      return '${number.substring(0, 3)} ${number.substring(3, 6)} ${number.substring(6)}';
    }
    return number;
  }
}


