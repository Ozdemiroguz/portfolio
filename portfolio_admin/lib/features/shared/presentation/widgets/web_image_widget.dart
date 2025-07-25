import 'package:flutter/material.dart';

class WebImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const WebImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    print('WebImageWidget: Loading image $imageUrl');

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          print('WebImageWidget: Image loaded successfully');
          return child;
        }

        return loadingWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        print('WebImageWidget error: $error');

        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: width != null ? (width! * 0.3).clamp(16, 32) : 24,
                    color: Colors.grey[600],
                  ),
                  if (width != null && width! > 60)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Yüklenemedi',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            );
      },
    );
  }
}
