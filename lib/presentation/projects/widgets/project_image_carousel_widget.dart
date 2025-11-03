import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/constants/app_sizes.dart';

/// Project image carousel widget
/// Displays project screenshots in a carousel
class ProjectImageCarouselWidget extends StatelessWidget {
  final List<String> images;

  const ProjectImageCarouselWidget({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 100),
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: images.map((imagePath) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white54,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

