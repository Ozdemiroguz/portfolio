import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class GlassmorphismLinkWidget extends StatelessWidget {
  final List<dynamic>? links;
  final String? title;

  const GlassmorphismLinkWidget({super.key, this.links, this.title});

  @override
  Widget build(BuildContext context) {
    if (links == null || links!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'LINKS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              links!.map((link) => _buildLinkButton(context, link)).toList(),
        ),
      ],
    );
  }

  Widget _buildLinkButton(BuildContext context, dynamic link) {
    // Önce platform'u kontrol et, yoksa type'ı kullan
    String linkType =
        link['platform']?.toString().toLowerCase() ??
        link['type']?.toString().toLowerCase() ??
        'unknown';
    String url = link['url']?.toString() ?? '';

    if (url.isEmpty) return const SizedBox();

    LinkInfo linkInfo = _getLinkInfo(linkType);

    return GestureDetector(
      onTap: () => _handleLinkTap(context, url),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          // CAMİMSİ EFEKT - Glassmorphism
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.02),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ASSET IMAGE ICON veya FALLBACK
            SizedBox(
              width: 16,
              height: 16,
              child: Image.asset(
                linkInfo.assetPath,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Asset yüklenemezse fallback icon göster
                  return Icon(
                    linkInfo.fallbackIcon,
                    color: Colors.white,
                    size: 14,
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            // LINK NAME
            Text(
              linkInfo.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinkInfo _getLinkInfo(String type) {
    switch (type) {
      case 'github':
        return LinkInfo(
          name: 'GitHub',
          assetPath: 'assets/images/github.png',
          fallbackIcon: Icons.code,
        );
      case 'playstore':
      case 'play_store':
      case 'googleplay':
        return LinkInfo(
          name: 'Play Store',
          assetPath: 'assets/images/playstore.png',
          fallbackIcon: Icons.shop,
        );
      case 'appstore':
      case 'app_store':
      case 'ios':
        return LinkInfo(
          name: 'App Store',
          assetPath: 'assets/images/appstore.png',
          fallbackIcon: Icons.apple,
        );
      case 'website':
      case 'web':
      case 'url':
        return LinkInfo(
          name: 'Website',
          assetPath: 'assets/images/website.png',
          fallbackIcon: Icons.web,
        );
      case 'demo':
      case 'live':
        return LinkInfo(
          name: 'Live Demo',
          assetPath: 'assets/images/live.webp',
          fallbackIcon: Icons.launch,
        );
      case 'youtube':
      case 'video':
        return LinkInfo(
          name: 'Video',
          assetPath: 'assets/images/youtube.png',
          fallbackIcon: Icons.play_circle,
        );
      case 'linkedin':
        return LinkInfo(
          name: 'LinkedIn',
          assetPath: 'assets/images/linkedin.png',
          fallbackIcon: Icons.business,
        );
      case 'twitter':
        return LinkInfo(
          name: 'Twitter',
          assetPath: 'assets/images/twitter.png',
          fallbackIcon: Icons.alternate_email,
        );
      case 'instagram':
        return LinkInfo(
          name: 'Instagram',
          assetPath: 'assets/images/instagram.png',
          fallbackIcon: Icons.camera_alt,
        );
      case 'email':
      case 'gmail':
        return LinkInfo(
          name: 'Email',
          assetPath: 'assets/images/gmail.png',
          fallbackIcon: Icons.email,
        );
      case 'download':
      case 'apk':
        return LinkInfo(
          name: 'Download',
          assetPath: 'assets/images/download.png',
          fallbackIcon: Icons.download,
        );
      default:
        return LinkInfo(
          name: type.toUpperCase(),
          assetPath: 'assets/images/unknown.png',
          fallbackIcon: Icons.link,
        );
    }
  }

  Future<void> _handleLinkTap(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // URL açılamazsa clipboard'a kopyala
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) {
          _showSnackBar(
            context,
            'Cannot open URL. Link copied to clipboard: $url',
            Colors.orange,
          );
        }
      }
    } catch (e) {
      // Hata durumunda clipboard'a kopyala
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        _showSnackBar(
          context,
          'Error opening URL. Link copied to clipboard: $url',
          Colors.red,
        );
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color.withOpacity(0.8),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class LinkInfo {
  final String name;
  final String assetPath;
  final IconData fallbackIcon;

  LinkInfo({
    required this.name,
    required this.assetPath,
    required this.fallbackIcon,
  });
}
