import 'package:equatable/equatable.dart';
import '../../core/utils/date_helpers.dart';

/// App data model
/// Represents an application/widget in the portfolio
class AppModel extends Equatable {
  final String id;
  final String type;
  final String title;
  final String description;
  final String icon;
  final String? iconImage;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int order;
  final Map<String, dynamic> data;
  
  // Translation keys (optional)
  final String? titleKey;
  final String? descriptionKey;

  const AppModel({
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

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'unknown',
      title: json['title'] ?? 'Application',
      description: json['description'] ?? 'No description available',
      icon: json['icon'] ?? '',
      iconImage: json['iconImage'],
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateHelpers.parseDateTime(json['createdAt']),
      updatedAt: DateHelpers.parseDateTime(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      order: json['order'] ?? 0,
      data: json['data'] != null ? Map<String, dynamic>.from(json['data'] as Map) : {},
      titleKey: json['titleKey'],
      descriptionKey: json['descriptionKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'icon': icon,
      'iconImage': iconImage,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'order': order,
      'data': data,
    };
  }

  // Type-specific data getters
  ProjectDataModel? get projectData =>
      type == 'project' ? ProjectDataModel.fromJson(data) : null;

  EducationDataModel? get educationData =>
      type == 'education' ? EducationDataModel.fromJson(data) : null;

  CareerDataModel? get careerData =>
      type == 'career' ? CareerDataModel.fromJson(data) : null;

  ContactDataModel? get contactData =>
      type == 'contact' ? ContactDataModel.fromJson(data) : null;

  AboutDataModel? get aboutData =>
      type == 'about' ? AboutDataModel.fromJson(data) : null;

  AchievementDataModel? get achievementData =>
      type == 'achievement' ? AchievementDataModel.fromJson(data) : null;

  ReferenceDataModel? get referenceData =>
      type == 'reference' ? ReferenceDataModel.fromJson(data) : null;

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

/// Project data model
class ProjectDataModel extends Equatable {
  final List<ProjectModel> projects;

  const ProjectDataModel({required this.projects});

  factory ProjectDataModel.fromJson(Map<String, dynamic> json) {
    return ProjectDataModel(
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'projects': projects.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [projects];
}

class ProjectModel extends Equatable {
  final String title;
  final String description;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? webUrl;
  final String? demoUrl;
  final List<String> technologies;
  final List<String> features;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int teamSize;
  final String role;
  final bool ownProject;
  final String? clientName;
  final Map<String, bool> displayOn;
  final List<String> images;

  const ProjectModel({
    required this.title,
    required this.description,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.webUrl,
    this.demoUrl,
    required this.technologies,
    required this.features,
    required this.status,
    this.startDate,
    this.endDate,
    required this.teamSize,
    required this.role,
    required this.ownProject,
    this.clientName,
    required this.displayOn,
    required this.images,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      githubUrl: json['githubUrl'],
      playStoreUrl: json['playStoreUrl'],
      appStoreUrl: json['appStoreUrl'],
      webUrl: json['webUrl'],
      demoUrl: json['demoUrl'],
      technologies: List<String>.from(json['technologies'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      status: json['status'] ?? 'unknown',
      startDate: json['startDate'] != null
          ? DateHelpers.parseDateTime(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateHelpers.parseDateTime(json['endDate'])
          : null,
      teamSize: json['teamSize'] ?? 1,
      role: json['role'] ?? '',
      ownProject: json['ownProject'] ?? true,
      clientName: json['clientName'],
      displayOn: json['displayOn'] != null
          ? Map<String, bool>.from(json['displayOn'])
          : {},
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'githubUrl': githubUrl,
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
      'webUrl': webUrl,
      'demoUrl': demoUrl,
      'technologies': technologies,
      'features': features,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'teamSize': teamSize,
      'role': role,
      'ownProject': ownProject,
      'clientName': clientName,
      'displayOn': displayOn,
      'images': images,
    };
  }

  @override
  List<Object?> get props => [
        title,
        description,
        githubUrl,
        playStoreUrl,
        appStoreUrl,
        webUrl,
        demoUrl,
        technologies,
        features,
        status,
        startDate,
        endDate,
        teamSize,
        role,
        ownProject,
        clientName,
        displayOn,
        images,
      ];
}

/// Education data model
class EducationDataModel extends Equatable {
  final Map<String, dynamic> data;

  const EducationDataModel({required this.data});

  factory EducationDataModel.fromJson(Map<String, dynamic> json) {
    return EducationDataModel(data: json);
  }

  Map<String, dynamic> toJson() => data;

  @override
  List<Object?> get props => [data];
}

/// Career data model
class CareerDataModel extends Equatable {
  final Map<String, dynamic> data;

  const CareerDataModel({required this.data});

  factory CareerDataModel.fromJson(Map<String, dynamic> json) {
    return CareerDataModel(data: json);
  }

  Map<String, dynamic> toJson() => data;

  @override
  List<Object?> get props => [data];
}

/// Contact data model
class ContactDataModel extends Equatable {
  final Map<String, dynamic> data;

  const ContactDataModel({required this.data});

  factory ContactDataModel.fromJson(Map<String, dynamic> json) {
    return ContactDataModel(data: json);
  }

  Map<String, dynamic> toJson() => data;

  @override
  List<Object?> get props => [data];
}

/// About data model
class AboutDataModel extends Equatable {
  final Map<String, dynamic> data;

  const AboutDataModel({required this.data});

  factory AboutDataModel.fromJson(Map<String, dynamic> json) {
    return AboutDataModel(data: json);
  }

  Map<String, dynamic> toJson() => data;

  @override
  List<Object?> get props => [data];
}

/// Achievement data model
class AchievementDataModel extends Equatable {
  final Map<String, dynamic> data;

  const AchievementDataModel({required this.data});

  factory AchievementDataModel.fromJson(Map<String, dynamic> json) {
    return AchievementDataModel(data: json);
  }

  Map<String, dynamic> toJson() => data;

  @override
  List<Object?> get props => [data];
}

/// Reference data model
class ReferenceDataModel extends Equatable {
  final Map<String, dynamic> data;

  const ReferenceDataModel({required this.data});

  factory ReferenceDataModel.fromJson(Map<String, dynamic> json) {
    return ReferenceDataModel(data: json);
  }

  Map<String, dynamic> toJson() => data;

  @override
  List<Object?> get props => [data];
}
