import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/app.dart';

class AppOverlay extends StatelessWidget {
  final App app;
  final VoidCallback onClose;

  const AppOverlay({super.key, required this.app, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Arka plan blur
            _buildBlurBackground(),

            // App container
            Center(child: _buildAppContainer()),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurBackground() {
    return GestureDetector(
      onTap: onClose, // Arka plana tıklayınca kapat
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3), // Açık tonlu overlay
          ),
        ),
      ),
    );
  }

  Widget _buildAppContainer() {
    return Container(
      width: 320,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // App icon ve title
                _buildAppHeader(),

                const SizedBox(height: 20),

                // App content
                Expanded(child: _buildAppContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        // App icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.2),
          ),
          child: Icon(_getAppIcon(), color: Colors.white, size: 40),
        ),

        const SizedBox(height: 16),

        // App title
        Text(
          app.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        // App type
        Text(
          app.type.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAppContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (app.description.isNotEmpty) ...[
            Text(
              'Description',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              app.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // App type specific content
          Expanded(child: _buildTypeSpecificContent()),
        ],
      ),
    );
  }

  Widget _buildTypeSpecificContent() {
    switch (app.type.toLowerCase()) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Details',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This is a project application. More details will be implemented.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEducationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Education information will be displayed here.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCareerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Career',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Career information will be displayed here.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildContactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Contact information will be displayed here.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'About information will be displayed here.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAchievementContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Achievement information will be displayed here.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildReferenceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'References',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Reference information will be displayed here.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Content',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This app content will be implemented.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  IconData _getAppIcon() {
    switch (app.type.toLowerCase()) {
      case 'project':
        return Icons.code;
      case 'education':
        return Icons.school;
      case 'career':
        return Icons.work;
      case 'contact':
        return Icons.contact_mail;
      case 'about':
        return Icons.person;
      case 'achievement':
        return Icons.emoji_events;
      case 'reference':
        return Icons.recommend;
      case 'camera':
        return Icons.camera_alt;
      case 'phone':
        return Icons.phone;
      case 'messages':
        return Icons.message;
      case 'game1':
      case 'game2':
      case 'game3':
        return Icons.games;
      default:
        return Icons.apps;
    }
  }
}
