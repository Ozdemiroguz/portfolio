import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Reads asset dimensions once so screenshots and logos can be told apart.
class _AssetSizeCache {
  static final Map<String, Future<Size>> _sizes = {};

  static Future<Size> of(String asset) {
    return _sizes.putIfAbsent(asset, () {
      final completer = Completer<Size>();
      final stream = AssetImage(asset).resolve(const ImageConfiguration());
      late final ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()),
          );
          info.dispose();
          stream.removeListener(listener);
        },
        onError: (_, _) {
          completer.complete(Size.zero);
          stream.removeListener(listener);
        },
      );
      stream.addListener(listener);
      return completer.future;
    });
  }
}

/// Picks a logo (square-ish image) and a screenshot (portrait image) from
/// the project's assets.
class _Visuals {
  final String? logo;
  final String? screenshot;
  final String? landscape;

  const _Visuals({this.logo, this.screenshot, this.landscape});
}

Future<_Visuals> _pickVisuals(List<String> images, String? iconImage) async {
  String? logo;
  String? screenshot;
  String? landscape;

  final candidates = [
    if (iconImage != null) iconImage,
    ...images,
  ];
  for (final asset in candidates.take(6)) {
    final size = await _AssetSizeCache.of(asset);
    if (size == Size.zero) continue;
    final ratio = size.width / size.height;
    if (ratio > 0.85 && ratio < 1.15) {
      logo ??= asset;
    } else if (ratio < 0.85) {
      screenshot ??= asset;
    } else {
      landscape ??= asset;
    }
    if (logo != null && screenshot != null) break;
  }
  return _Visuals(logo: logo, screenshot: screenshot, landscape: landscape);
}

/// Card header: gradient backdrop, app logo and a phone-framed screenshot.
class ClassicProjectVisualWidget extends StatelessWidget {
  final List<String> images;
  final String? iconImage;
  final String emoji;
  final double height;

  const ClassicProjectVisualWidget({
    super.key,
    required this.images,
    required this.iconImage,
    required this.emoji,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FutureBuilder<_Visuals>(
        future: _pickVisuals(images, iconImage),
        builder: (context, snapshot) {
          final visuals = snapshot.data ?? const _Visuals();
          return _Backdrop(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (visuals.screenshot != null)
                  Positioned(
                    right: AppSizes.paddingLg,
                    top: AppSizes.paddingLg,
                    bottom: -height * 0.35,
                    child: _PhoneMock(asset: visuals.screenshot!),
                  )
                else if (visuals.landscape != null)
                  Positioned(
                    left: AppSizes.paddingXl + 60,
                    right: AppSizes.paddingLg,
                    top: AppSizes.paddingLg,
                    bottom: -height * 0.2,
                    child: _LandscapeMock(asset: visuals.landscape!),
                  ),
                Positioned(
                  left: AppSizes.paddingLg,
                  top: AppSizes.paddingLg,
                  child: _Logo(asset: visuals.logo, emoji: emoji),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  final Widget child;

  const _Backdrop({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.withOpacity(AppColors.primary, 0.28),
              AppColors.withOpacity(AppColors.backgroundDark3, 0.9),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String? asset;
  final String emoji;

  const _Logo({required this.asset, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark1,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(Colors.black, 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: asset == null
          ? Center(child: Text(emoji, style: const TextStyle(fontSize: 30)))
          : Image.asset(asset!, fit: BoxFit.cover),
    );
  }
}

class _PhoneMock extends StatelessWidget {
  final String asset;

  const _PhoneMock({required this.asset});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 19.5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.withOpacity(Colors.white, 0.25), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.withOpacity(Colors.black, 0.5),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}

class _LandscapeMock extends StatelessWidget {
  final String asset;

  const _LandscapeMock({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.25), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(Colors.black, 0.5),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.topCenter),
      ),
    );
  }
}
