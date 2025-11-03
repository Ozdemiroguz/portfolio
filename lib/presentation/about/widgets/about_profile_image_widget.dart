import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Profile image widget for About screen
/// Displays profile photo with glass morphism effect
class AboutProfileImageWidget extends StatelessWidget {
  final String imageUrl;

  const AboutProfileImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.withOpacity(Colors.white, 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(Colors.black, 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // DİKEY boyut için height'ı width'in 4/3 katı yap (3:4 ratio - portrait)
            final height = constraints.maxWidth * 4 / 3;
            return SizedBox(
              height: height,
              width: double.infinity,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover, // Tam doldur
                alignment: Alignment.topCenter, // Üstten başlat (kafa görünsün)
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 100,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
