import 'package:flutter/material.dart';
import '../models/app.dart';
import '../utils/app_icons.dart';

class AppIcon extends StatelessWidget {
  final String title;
  final String? iconPath;
  final App? app;
  final VoidCallback? onTap;
  final double size;
  final bool isSelected;
  final IconData? fallbackIcon;
  final bool showTitle;

  const AppIcon({
    super.key,
    required this.title,
    this.iconPath,
    this.app,
    this.onTap,
    this.size = 60,
    this.isSelected = false,
    this.fallbackIcon,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 10,
        height: showTitle ? size + 30 : size, // Text varsa extra alan
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.2),
                color: isSelected ? Colors.white.withOpacity(0.2) : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.2),
                child: _buildIcon(),
              ),
            ),

            // Text label - sadece showTitle true ise
            if (showTitle) ...[
              // Spacing
              const SizedBox(height: 6),

              // Text label - daha büyük alan
              SizedBox(
                width: size + 10,
                height: 20,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getIconPath() {
    // Eğer app objesi varsa, mantığı uygula
    if (app != null) {
      if (app!.type.toLowerCase() == 'project') {
        // Project ise: images listesinin ilk resmi veya default project icon
        if (app!.images.isNotEmpty) {
          return app!.images.first;
        } else {
          return AppIconUtils.getAssetByType('project');
        }
      } else {
        // Project değilse: type'a göre asset (utils kullan)
        return AppIconUtils.getAssetByType(app!.type);
      }
    }

    // App objesi yoksa iconPath kullan
    return iconPath ?? AppIconUtils.getAssetByType('unknown');
  }

  Widget _buildIcon() {
    String finalIconPath = _getIconPath();

    // Debug: iconPath'i görmek için
    debugPrint('AppIcon finalIconPath: $finalIconPath');

    // Eğer iconPath bir URL ise network image, değilse asset image kullan
    if (finalIconPath.startsWith('http')) {
      return Image.network(
        finalIconPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon();
        },
      );
    } else {
      // Asset image - Flutter otomatik olarak assets/ ekliyor, biz sadece images/ ile başlatalım
      String assetPath;
      if (finalIconPath.startsWith('assets/images/')) {
        // assets/images/ var, sadece images/ kısmını al
        assetPath = finalIconPath.substring(7); // "assets/" kısmını çıkar
      } else if (finalIconPath.startsWith('images/')) {
        // Zaten images/ ile başlıyor
        assetPath = finalIconPath;
      } else {
        // Sadece dosya adı verilmiş
        assetPath = 'images/$finalIconPath';
      }

      // Eğer uzantı yoksa .png ekle
      if (!assetPath.contains('.')) {
        assetPath += '.png';
      }

      debugPrint('Final assetPath: $assetPath');

      return Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon();
        },
      );
    }
  }

  Widget _buildFallbackIcon() {
    // App türüne göre fallback icon belirle
    IconData iconData;
    if (app != null) {
      String fallbackIconName = AppIconUtils.getFallbackIconByType(app!.type);
      iconData = _getIconDataFromString(fallbackIconName);
    } else {
      iconData = fallbackIcon ?? Icons.apps;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Icon(iconData, color: Colors.white, size: size * 0.6),
    );
  }

  IconData _getIconDataFromString(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'work_outline':
        return Icons.work_outline;
      case 'contact_mail':
        return Icons.contact_mail;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'person':
        return Icons.person;
      case 'recommend':
        return Icons.recommend;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'phone':
        return Icons.phone;
      case 'message':
        return Icons.message;
      case 'games':
        return Icons.games;
      case 'download':
        return Icons.download;
      default:
        return Icons.apps;
    }
  }
}
