import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../about/about_screen.dart';
import '../../career/career_screen.dart';
import '../../contact/contact_screen.dart';
import '../../projects/projects_screen.dart';
import '../../achievement/achievement_screen.dart';
import '../../camera/camera_screen.dart';
import '../../messages/messages_screen.dart';
import '../../phone/phone_screen.dart';
import '../../browser/browser_screen.dart';
import '../../snake/snake_screen.dart';
import '../../tetris/tetris_screen.dart';
import '../../gallery/gallery_screen.dart';
import '../../cv/cv_screen.dart';
import '../../map/map_screen.dart';

/// App screen wrapper widget
/// Wraps app screens with back button and background
class AppScreenWrapperWidget extends StatelessWidget {
  final AppEntity app;
  final VoidCallback onBack;

  const AppScreenWrapperWidget({
    super.key,
    required this.app,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.backgroundGradient,
        ),
      ),
      child: Stack(
        children: [
          // Content based on app type
          _buildAppContent(),

          // Back button
          Positioned(
            top: 32,
            left: 20,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.paddingSm),
                decoration: BoxDecoration(
                  // Harita sayfası için daha koyu, diğerleri için açık
                  color:
                      app.type == 'map'
                          ? const Color(0xCC000000) // Koyu siyah, yarı saydam
                          : AppColors.withOpacity(Colors.white, 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(
                    color:
                        app.type == 'map'
                            ? const Color(0x4DFFFFFF) // Açık kenarlık
                            : AppColors.withOpacity(Colors.white, 0.2),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color:
                      app.type == 'map'
                          ? Colors
                              .white // Harita için beyaz ikon
                          : AppColors.textPrimary,
                  size: AppSizes.iconSm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppContent() {
    switch (app.type) {
      case AppStrings.appTypeAbout:
        return AboutScreen(app: app);
      case AppStrings.appTypeCareer:
        return CareerScreen(app: app);
      case AppStrings.appTypeContact:
        return ContactScreen(app: app);
      case AppStrings.appTypeProject:
        return ProjectsScreen(app: app);
      case AppStrings.appTypeAchievement:
        return AchievementScreen(app: app);
      case 'camera':
        return CameraScreen(app: app);
      case 'messages':
        return MessagesScreen(app: app);
      case 'phone':
        return PhoneScreen(app: app);
      case 'browser':
        return BrowserScreen(app: app);
      case 'snake':
        return SnakeScreen(app: app);
      case 'tetris':
        return TetrisScreen(app: app);
      case 'gallery':
        return GalleryScreen(app: app);
      case 'cv':
        return CvScreen(app: app);
      case 'map':
        return MapScreen(app: app);
      default:
        return Center(
          child: Text(
            tr(
              'portfolio.appTypeNotImplemented',
              namedArgs: {'type': app.type},
            ),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        );
    }
  }
}
