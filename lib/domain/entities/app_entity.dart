import 'package:equatable/equatable.dart';
import 'about_data_entity.dart';
import 'career_data_entity.dart';
import 'contact_data_entity.dart';
import 'project_data_entity.dart';
import 'achievement_data_entity.dart';

/// App domain entity
class AppEntity extends Equatable {
  final String id;
  final String type;
  final String title;
  final String description;
  final String icon;
  final String? iconImage; // Custom icon image (if null, use emoji icon)
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int order;
  final Object? data;
  
  // Translation keys (optional)
  final String? titleKey;
  final String? descriptionKey;

  const AppEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    this.iconImage,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.order,
    required this.data,
    this.titleKey,
    this.descriptionKey,
  });

  /// Get about data (type-safe)
  AboutDataEntity? get aboutData {
    if (type == 'about' && data is AboutDataEntity) {
      return data as AboutDataEntity;
    }
    return null;
  }

  /// Get career data (type-safe)
  CareerDataEntity? get careerData {
    if (type == 'career' && data is CareerDataEntity) {
      return data as CareerDataEntity;
    }
    return null;
  }

  /// Get contact data (type-safe)
  ContactDataEntity? get contactData {
    if (type == 'contact' && data is ContactDataEntity) {
      return data as ContactDataEntity;
    }
    return null;
  }

  /// Get project data (type-safe)
  ProjectDataEntity? get projectData {
    if (type == 'project' && data is ProjectDataEntity) {
      return data as ProjectDataEntity;
    }
    return null;
  }

  /// Get achievement data (type-safe)
  AchievementDataEntity? get achievementData {
    if (type == 'achievement' && data is AchievementDataEntity) {
      return data as AchievementDataEntity;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        icon,
        iconImage,
        images,
        createdAt,
        updatedAt,
        isActive,
        order,
        data,
        titleKey,
        descriptionKey,
      ];
}
