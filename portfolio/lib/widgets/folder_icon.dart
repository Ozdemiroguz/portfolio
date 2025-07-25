import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/folder.dart';
import '../models/app.dart';
import '../utils/app_icons.dart';

class FolderIcon extends StatelessWidget {
  final Folder folder;
  final List<App> apps; // Folder içindeki uygulamalar
  final VoidCallback onTap;
  final double size;

  const FolderIcon({
    super.key,
    required this.folder,
    required this.apps,
    required this.onTap,
    this.size = 60, // AppIcon ile aynı default size
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 10, // AppIcon ile aynı genişlik
        height: size + 30, // AppIcon ile aynı yükseklik (icon + text)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Folder container - Glassmorphism efekti
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.2),
                child: Stack(
                  children: [
                    // Glassmorphism backdrop
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.03),
                          ],
                        ),
                      ),
                    ),
                    // App icons grid
                    _buildAppIconsGrid(),
                  ],
                ),
              ),
            ),

            // Spacing - AppIcon ile aynı
            const SizedBox(height: 6),

            // Folder name - AppIcon ile TAM AYNI layout
            SizedBox(
              width: size + 10, // AppIcon ile aynı genişlik
              height: 20, // AppIcon ile aynı yükseklik
              child: Text(
                folder.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.14, // AppIcon ile TAM AYNI
                  fontWeight: FontWeight.w500, // AppIcon ile TAM AYNI
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIconsGrid() {
    // En fazla 3 uygulamayı göster (4. pozisyon sayaç için ayrılmış)
    final displayApps = apps.take(3).toList();

    // Eğer hiç uygulama yoksa boş container
    if (displayApps.isEmpty) {
      return Container(); // Tamamen boş, arka plan yok
    }

    return Padding(
      padding: EdgeInsets.all(size * 0.05), // Daha az padding
      child: _buildAppGrid(displayApps),
    );
  }

  Widget _buildAppGrid(List<App> displayApps) {
    final totalApps = apps.length;
    final remainingCount =
        totalApps - 3; // 3 icon gösterdikten sonra kalan sayı

    // Her zaman 2x2 grid formatında göster
    return Column(
      children: [
        // Üst satır
        Expanded(
          child: Row(
            children: [
              // Sol üst - İlk app
              Expanded(
                child:
                    displayApps.isNotEmpty
                        ? _buildMiniAppItem(displayApps[0])
                        : Container(), // Boş slot yok
              ),
              const SizedBox(width: 2), // Daha az spacing
              // Sağ üst - İkinci app
              Expanded(
                child:
                    displayApps.length > 1
                        ? _buildMiniAppItem(displayApps[1])
                        : Container(), // Boş slot yok
              ),
            ],
          ),
        ),
        const SizedBox(height: 2), // Daha az spacing
        // Alt satır
        Expanded(
          child: Row(
            children: [
              // Sol alt - Üçüncü app
              Expanded(
                child:
                    displayApps.length > 2
                        ? _buildMiniAppItem(displayApps[2])
                        : Container(), // Boş slot yok
              ),
              const SizedBox(width: 2), // Daha az spacing
              // Sağ alt - Dördüncü pozisyon (sayı + +)
              Expanded(
                child:
                    totalApps > 3
                        ? _buildMoreAppsIndicator(remainingCount)
                        : Container(), // Boş slot yok
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniAppItem(App app) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        size * 0.15,
      ), // AppIcon ile aynı radius oranı
      child: _buildAppContent(app), // Sadece content, arka plan yok
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
      ),
    );
  }

  Widget _buildMoreAppsIndicator(int remainingCount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.15),
        color: Colors.black.withOpacity(0.6), // Koyu arka plan
      ),
      child: Center(
        child: Text(
          '+$remainingCount',
          style: TextStyle(
            color: Colors.white, // Beyaz yazı
            fontSize: size * 0.15, // Biraz büyüttüm
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppContent(App app) {
    // Projeler için: önce images'dan, yoksa asset'ten
    if (app.type == 'project') {
      if (app.images.isNotEmpty) {
        // Network image kullanılıyor
        return Image.network(
          app.images.first,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => _buildAssetIcon(app.type),
        );
      }
      return _buildAssetIcon(app.type);
    }

    // Diğer uygulamalar için sabit asset icon'ları
    return _buildAssetIcon(app.type);
  }

  Widget _buildAssetIcon(String type) {
    final assetPath = _getAssetIconPath(type);

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildAppIconByType(type),
      );
    }
    return _buildAppIconByType(type);
  }

  String? _getAssetIconPath(String type) {
    return AppIconUtils.getAssetByType(type);
  }

  Widget _buildAppIconByType(String type) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'project':
        iconData = Icons.code;
        iconColor = const Color(0xFF2196F3);
        break;
      case 'career':
        iconData = Icons.work;
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'education':
        iconData = Icons.school;
        iconColor = const Color(0xFF9C27B0);
        break;
      case 'about':
        iconData = Icons.person;
        iconColor = const Color(0xFF607D8B);
        break;
      case 'contact':
        iconData = Icons.contact_mail;
        iconColor = const Color(0xFFFF5722);
        break;
      case 'achievement':
        iconData = Icons.emoji_events;
        iconColor = const Color(0xFFFFEB3B);
        break;
      case 'reference':
        iconData = Icons.recommend;
        iconColor = const Color(0xFF795548);
        break;
      case 'bottom_app':
        iconData = Icons.apps;
        iconColor = const Color(0xFF3F51B5);
        break;
      default:
        iconData = Icons.apps;
        iconColor = const Color(0xFF757575);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [iconColor.withOpacity(0.8), iconColor],
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: Colors.white,
          size: 12, // Daha küçük icon boyutu
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(
          int.parse(colorString.substring(1), radix: 16) + 0xFF000000,
        );
      }
      return const Color(0xFF2196F3); // Default blue
    } catch (e) {
      return const Color(0xFF2196F3); // Default blue
    }
  }
}
