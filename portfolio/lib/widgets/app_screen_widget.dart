import 'package:flutter/material.dart';
import '../models/app.dart';
import 'project_app_widget.dart';
import 'about_app_widget.dart';
import 'contact_app_widget.dart';
import 'career_app_widget.dart';
import 'achievement_app_widget.dart';
import 'reference_app_widget.dart';
import 'game_screen_widget.dart';

class AppScreenWidget extends StatelessWidget {
  final App openApp;
  final VoidCallback onBackPressed;

  const AppScreenWidget({
    super.key,
    required this.openApp,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Oyun ekranları için özel handling
    if (openApp.type == 'game1' || openApp.type == 'game2') {
      return GameScreenWidget(
        gameType: openApp.type,
        onBackPressed: onBackPressed,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Stack(
        children: [
          // App content - tam ekran
          AppContentWidget(openApp: openApp),

          // Geri butonu - sol üst köşede, içeriğin üstünde
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: IconButton(
                onPressed: onBackPressed,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppContentWidget extends StatelessWidget {
  final App openApp;

  const AppContentWidget({super.key, required this.openApp});

  @override
  Widget build(BuildContext context) {
    switch (openApp.type) {
      case 'project':
        return _buildProjectContent();
      case 'education':
        return _buildEducationContent();
      case 'career':
        return _buildCareerContent();
      case 'contact':
        return _buildContactContent();
      case 'about':
        return _buildAboutContent();
      case 'achievement':
        return _buildAchievementContent();
      case 'reference':
        return _buildReferenceContent();
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildProjectContent() {
    return ProjectAppWidget(openApp: openApp);
  }

  Widget _buildEducationContent() {
    return DefaultAppContentWidget(
      app: openApp,
      icon: Icons.school,
      primaryColor: Colors.green,
    );
  }

  Widget _buildCareerContent() {
    return CareerAppWidget(openApp: openApp);
  }

  Widget _buildContactContent() {
    return ContactAppWidget(openApp: openApp);
  }

  Widget _buildAboutContent() {
    return AboutAppWidget(openApp: openApp);
  }

  Widget _buildAchievementContent() {
    return AchievementAppWidget(openApp: openApp);
  }

  Widget _buildReferenceContent() {
    return ReferenceAppWidget(openApp: openApp);
  }

  Widget _buildDefaultContent() {
    return DefaultAppContentWidget(
      app: openApp,
      icon: Icons.apps,
      primaryColor: Colors.grey,
    );
  }
}

class DefaultAppContentWidget extends StatelessWidget {
  final App app;
  final IconData icon;
  final Color primaryColor;

  const DefaultAppContentWidget({
    super.key,
    required this.app,
    required this.icon,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Üst boşluk - geri butonu için
          const SizedBox(height: 100),

          // İçerik container
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // Icon ve başlık
                  Icon(icon, size: 60, color: primaryColor.withOpacity(0.8)),
                  const SizedBox(height: 15),
                  Text(
                    app.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    app.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  // İçerik
                  _buildAppSpecificContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSpecificContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Data varsa göster
          if (app.data.isNotEmpty) ...[
            _buildDataContent(),
          ] else ...[
            // Varsayılan içerik
            _buildDefaultContentSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildDataContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          app.data.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.value.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDefaultContentSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No content available yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'More information will be added soon.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
