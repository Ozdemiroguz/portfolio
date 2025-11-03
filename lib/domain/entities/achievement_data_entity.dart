import 'package:equatable/equatable.dart';

/// Single achievement entity
class AchievementEntity extends Equatable {
  final String title;
  final String date;
  final String description;
  final String issuer;
  
  // Translation keys (optional)
  final String? titleKey;
  final String? descriptionKey;
  final String? issuerKey;

  const AchievementEntity({
    required this.title,
    required this.date,
    required this.description,
    required this.issuer,
    this.titleKey,
    this.descriptionKey,
    this.issuerKey,
  });

  @override
  List<Object?> get props => [
        title,
        date,
        description,
        issuer,
        titleKey,
        descriptionKey,
        issuerKey,
      ];
}

/// Achievement data entity
class AchievementDataEntity extends Equatable {
  final List<AchievementEntity> achievements;
  final String profileImage;

  const AchievementDataEntity({
    required this.achievements,
    this.profileImage = 'assets/images/my_photo.webp',
  });

  @override
  List<Object?> get props => [achievements, profileImage];
}
