import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Data card widget for About screen
/// Displays a key-value pair in a card
class AboutDataCardWidget extends StatelessWidget {
  final String fieldKey;
  final dynamic value;
  final String? valueKey;
  final List<String>? valueKeys;

  const AboutDataCardWidget({
    super.key,
    required this.fieldKey,
    required this.value,
    this.valueKey,
    this.valueKeys,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.withOpacity(Colors.white, 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field name
          Text(
            tr(fieldKey),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spacingSm),

          // Field value
          _buildValueContent(value, valueKey, valueKeys),
        ],
      ),
    );
  }

  /// Build value content based on type
  Widget _buildValueContent(
    dynamic value,
    String? valueKey,
    List<String>? valueKeys,
  ) {
    if (value is String) {
      // If translation key exists, try to translate; otherwise use original value
      final displayValue = valueKey != null ? _tryTranslate(valueKey, value) : value;
      
      return Text(
        displayValue,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          height: 1.5,
        ),
      );
    }

    if (value is List) {
      return Wrap(
        spacing: AppSizes.spacingSm,
        runSpacing: AppSizes.spacingSm,
        children: value.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          // If translation keys exist, use them; otherwise use original value
          final displayValue = (valueKeys != null && 
                                index < valueKeys.length && 
                                valueKeys[index].isNotEmpty)
              ? _tryTranslate(valueKeys[index], item.toString())
              : item.toString();
          
          return Chip(
            label: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.withOpacity(AppColors.primary, 0.2),
            side: BorderSide(
              color: AppColors.withOpacity(AppColors.primary, 0.4),
            ),
          );
        }).toList(),
      );
    }

    if (value is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacingSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key}: ',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Text(
      value.toString(),
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
    );
  }

  /// Try to translate a key, return original value if translation fails or not found
  String _tryTranslate(String key, String originalValue) {
    try {
      final translated = tr(key);
      // If translation returns the same key (meaning translation not found), return original value
      if (translated == key) {
        return originalValue;
      }
      return translated;
    } catch (e) {
      return originalValue;
    }
  }
}
