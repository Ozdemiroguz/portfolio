import 'package:equatable/equatable.dart';

/// Single project entity
class ProjectEntity extends Equatable {
  final String title;
  final String description;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? linkedinUrl;
  final String? webUrl;
  final String? demoUrl;
  final List<String> technologies;
  final List<String> features;
  final String status;
  final String startDate;
  final String? endDate;
  final int? teamSize;
  final String? role;
  final bool ownProject;
  final String? clientName;
  final List<String> images;
  
  // Translation keys (optional)
  final String? titleKey;
  final String? descriptionKey;
  final List<String>? technologiesKeys;
  final List<String>? featuresKeys;
  final String? roleKey;
  final String? clientNameKey;

  const ProjectEntity({
    required this.title,
    required this.description,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.linkedinUrl,
    this.webUrl,
    this.demoUrl,
    required this.technologies,
    required this.features,
    required this.status,
    required this.startDate,
    this.endDate,
    this.teamSize,
    this.role,
    required this.ownProject,
    this.clientName,
    required this.images,
    this.titleKey,
    this.descriptionKey,
    this.technologiesKeys,
    this.featuresKeys,
    this.roleKey,
    this.clientNameKey,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        githubUrl,
        playStoreUrl,
        appStoreUrl,
        linkedinUrl,
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
        images,
        titleKey,
        descriptionKey,
        technologiesKeys,
        featuresKeys,
        roleKey,
        clientNameKey,
      ];
}
/// Project data entity
class ProjectDataEntity extends Equatable {
  final List<ProjectEntity> projects;

  const ProjectDataEntity({
    required this.projects,
  });

  @override
  List<Object?> get props => [projects];
}

