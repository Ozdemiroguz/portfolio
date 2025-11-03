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

