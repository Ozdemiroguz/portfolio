import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Gallery screen
/// Displays a grid of images
class GalleryScreen extends StatefulWidget {
  final AppEntity app;

  const GalleryScreen({super.key, required this.app});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _selectedImage;

  List<String> _getImages() {
    List<String> images = [];

    if (widget.app.data != null) {
      if (widget.app.data is Map<String, dynamic>) {
        final data = widget.app.data as Map<String, dynamic>;
        final imagesData = data['images'];
        if (imagesData != null && imagesData is List) {
          images =
              imagesData
                  .map((e) => e.toString())
                  .where((e) => e.isNotEmpty)
                  .toList()
                  .reversed
                  .toList();
        }
      }
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    final images = _getImages();

    return Stack(
      children: [
        Container(
          color: AppColors.backgroundDark1,
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        '${images.length}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.spacingMd),

                // Image grid
                Expanded(
                  child:
                      images.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library_outlined,
                                  size: 64,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tr('gallery.empty'),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : GridView.builder(
                            // reverse: true,
                            padding: const EdgeInsets.all(AppSizes.paddingMd),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              final imagePath = images[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImage = imagePath;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.withOpacity(
                                      Colors.white,
                                      0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusSm,
                                    ),
                                    border: Border.all(
                                      color: AppColors.withOpacity(
                                        Colors.white,
                                        0.1,
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusSm,
                                    ),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: AppColors.withOpacity(
                                            Colors.white,
                                            0.05,
                                          ),
                                          child: Icon(
                                            Icons.broken_image,
                                            color: AppColors.textSecondary,
                                          ),
                                        );
                                      },
                                      frameBuilder: (
                                        context,
                                        child,
                                        frame,
                                        wasSynchronouslyLoaded,
                                      ) {
                                        if (wasSynchronouslyLoaded ||
                                            frame != null) {
                                          return child;
                                        }
                                        return Container(
                                          color: AppColors.withOpacity(
                                            Colors.white,
                                            0.05,
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primary,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),

        // Image viewer overlay
        if (_selectedImage != null)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedImage = null;
              });
            },
            child: Container(
              color: Colors.black.withValues(alpha: 0.9),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Image with zoom
                    Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.asset(
                          _selectedImage!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 64,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Close button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
