import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';

/// Camera screen
/// Shows a simple message
class CameraScreen extends StatelessWidget {
  final AppEntity app;

  const CameraScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDark1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text with padding on left and right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                tr('camera.message'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
