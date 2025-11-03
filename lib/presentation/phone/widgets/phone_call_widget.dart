import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/phone_state.dart';

/// Phone call widget - shows during active call
class PhoneCallWidget extends StatelessWidget {
  final String number;
  final PhoneCallStatus callStatus;
  final VoidCallback onEndCall;

  const PhoneCallWidget({
    super.key,
    required this.number,
    required this.callStatus,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contact avatar
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            // Contact name/number
            Text(
              number.isEmpty
                  ? tr('phone.call.portfolioBot')
                  : _formatNumber(number),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            // Call status
            Text(
              _getStatusText(),
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // End call button
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withValues(alpha: 0.2),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEndCall,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (callStatus) {
      case PhoneCallStatus.dialing:
        return tr('phone.call.dialing');
      case PhoneCallStatus.connecting:
        return tr('phone.call.connecting');
      case PhoneCallStatus.connected:
        return tr('phone.call.connected');
      default:
        return '';
    }
  }

  String _formatNumber(String number) {
    if (number.length <= 10) {
      return number;
    }
    return number;
  }
}
