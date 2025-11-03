import 'package:equatable/equatable.dart';

/// About data entity
class AboutDataEntity extends Equatable {
  final String fullName;
  final String title;
  final String bio;
  final String location;
  final String birthDate;
  final String education;
  final List<String> interests;
  final String profileImage;
  
  // Translation keys (optional)
  final String? fullNameKey;
  final String? titleKey;
  final String? bioKey;
  final String? locationKey;
  final String? birthDateKey;
  final String? educationKey;
  final List<String>? interestsKeys;

  const AboutDataEntity({
    required this.fullName,
    required this.title,
    required this.bio,
    required this.location,
    required this.birthDate,
    required this.education,
    required this.interests,
    this.profileImage = 'assets/images/my_photo.webp',
    this.fullNameKey,
    this.titleKey,
    this.bioKey,
    this.locationKey,
    this.birthDateKey,
    this.educationKey,
    this.interestsKeys,
  });

  @override
  List<Object?> get props => [
        fullName,
        title,
        bio,
        location,
        birthDate,
        education,
        interests,
        profileImage,
        fullNameKey,
        titleKey,
        bioKey,
        locationKey,
        birthDateKey,
        educationKey,
        interestsKeys,
      ];
}
