import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// App icon widget
/// Displays an app icon with label
class AppIconWidget extends StatelessWidget {
  final AppEntity app;
  final VoidCallback onTap;
  final double size;

  const AppIconWidget({
    super.key,
    required this.app,
    required this.onTap,
    this.size = AppSizes.appIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: size + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.withOpacity(AppColors.primary, 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: AppColors.withOpacity(AppColors.primary, 0.4),
                  width: 2,
                ),
              ),
              child: _buildIcon(),
            ),

            const SizedBox(height: AppSizes.spacingXs),

            // Label
            Text(
              _getTitle(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Sadece icon verisini kullan, yoksa basit fallback
    final iconText = _getIcon();

    return Center(
      child: Text(
        iconText,
        style: TextStyle(
          fontSize: size * 0.5,
          height: 1.0,
          letterSpacing: 0,
          fontFamily: null, // System default font kullan (emoji desteği için)
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Get icon from data, fallback to default emoji
  String _getIcon() {
    // Icon string'ini temizle (trim, boşlukları kaldır)
    final cleanIcon = app.icon.trim();
    
    // Sadece icon verisini kullan, iconImage kullanma
    if (cleanIcon.isNotEmpty) {
      // Bazı emoji'ler sistemde render edilmeyebilir, emoji kontrolü yap
      return _ensureValidEmoji(cleanIcon);
    }
    // Basit fallback
    return '📱';
  }

  /// Ensure emoji is valid and renderable
  String _ensureValidEmoji(String emoji) {
    // Boş kontrolü
    if (emoji.isEmpty) {
      return '📱';
    }
    
    // Emoji string'ini normalize et (variation selector'ları temizle)
    final normalized = emoji
        .replaceAll('\uFE0F', '') // Variation selector 16 (VS16) kaldır
        .replaceAll('\uFE0E', '') // Variation selector 15 (VS15) kaldır
        .trim();
    
    // Normalize edilmiş emoji boşsa fallback kullan
    if (normalized.isEmpty) {
      return '📱';
    }
    
    return normalized;
  }

  /// Get title from translation key or use original title
  String _getTitle() {
    if (app.titleKey != null && app.titleKey!.isNotEmpty) {
      try {
        final translated = tr(app.titleKey!);
        // If translation returns the same key (meaning translation not found), return original
        if (translated != app.titleKey) {
          return translated;
        }
      } catch (e) {
        // If translation fails, fall back to original title
      }
    }
    return app.title;
  }
}
