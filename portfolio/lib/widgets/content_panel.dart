import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../models/app.dart';

class ContentPanel extends StatelessWidget {
  final Portfolio portfolio;
  final App? currentApp;
  final bool isMobile;

  const ContentPanel({
    super.key,
    required this.portfolio,
    this.currentApp,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _parseColor(portfolio.theme.backgroundColor).withValues(alpha: 0.9),
            _parseColor(portfolio.theme.primaryColor).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile) ...[
              // Desktop - Sabit hoş geldin paneli
              _buildWelcomeSection(),
            ] else ...[
              // Mobile - Scrollable içerik
              _buildMobileContent(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profil fotoğrafı
        if (portfolio.profilePhoto != null)
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(portfolio.profilePhoto!),
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        const SizedBox(height: 20),

        // İsim ve başlık
        Text(
          portfolio.title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _parseColor(portfolio.theme.textColor),
          ),
        ),
        const SizedBox(height: 10),

        // Açıklama
        Text(
          portfolio.description,
          style: TextStyle(
            fontSize: 16,
            color: _parseColor(
              portfolio.theme.textColor,
            ).withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Yetenekler
        if (portfolio.skills.isNotEmpty) ...[
          Text(
            'Yetenekler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _parseColor(portfolio.theme.textColor),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                portfolio.skills
                    .map(
                      (skill) => Chip(
                        label: Text(skill),
                        backgroundColor: _parseColor(
                          portfolio.theme.primaryColor,
                        ).withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: _parseColor(portfolio.theme.textColor),
                          fontSize: 12,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Sosyal medya linkleri
        if (portfolio.socialLinks.isNotEmpty) ...[
          Text(
            'İletişim',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _parseColor(portfolio.theme.textColor),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children:
                portfolio.socialLinks
                    .where((link) => link.url != null && link.url!.isNotEmpty)
                    .map((link) => _buildSocialButton(link))
                    .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kısa tanıtım
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoş Geldiniz!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _parseColor(portfolio.theme.textColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                portfolio.description,
                style: TextStyle(
                  fontSize: 14,
                  color: _parseColor(
                    portfolio.theme.textColor,
                  ).withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // Seçili uygulama içeriği
        if (currentApp != null) ...[
          const SizedBox(height: 20),
          _buildCurrentAppContent(),
        ],
      ],
    );
  }

  Widget _buildCurrentAppContent() {
    if (currentApp == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentApp!.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _parseColor(portfolio.theme.textColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentApp!.description,
            style: TextStyle(
              fontSize: 14,
              color: _parseColor(
                portfolio.theme.textColor,
              ).withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Uygulama detayına git
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _parseColor(portfolio.theme.primaryColor),
              foregroundColor: Colors.white,
            ),
            child: const Text('Detayları Gör'),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(SocialLink link) {
    IconData icon;
    Color color;

    switch (link.type.toLowerCase()) {
      case 'github':
        icon = Icons.code;
        color = Colors.black;
        break;
      case 'linkedin':
        icon = Icons.business;
        color = const Color(0xFF0077B5);
        break;
      case 'twitter':
        icon = Icons.alternate_email;
        color = const Color(0xFF1DA1F2);
        break;
      case 'email':
        icon = Icons.email;
        color = Colors.red;
        break;
      default:
        icon = Icons.link;
        color = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: () {
          // URL açma işlemi
          // url_launcher paketi eklenebilir
        },
        tooltip: link.type,
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
      return Colors.white; // Default
    } catch (e) {
      return Colors.white; // Default
    }
  }
}
