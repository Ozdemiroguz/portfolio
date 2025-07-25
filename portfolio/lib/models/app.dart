import 'package:cloud_firestore/cloud_firestore.dart';

// Helper method to parse DateTime from Firestore
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

class App {
  final String id;
  final String type;
  final String title;
  final String description;
  final String icon;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int order;
  final Map<String, dynamic> data;

  App({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.order,
    required this.data,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'] ?? '',
      type: json['type'] ?? 'unknown',
      title: json['title'] ?? 'Uygulama',
      description: json['description'] ?? 'Açıklama bulunamadı',
      icon: json['icon'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      order: json['order'] ?? 0,
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'icon': icon,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'order': order,
      'data': data,
    };
  }

  // App türüne göre özel veri getirme metodları
  ProjectData? get projectData =>
      type == 'project' ? ProjectData.fromJson(data) : null;

  EducationData? get educationData =>
      type == 'education' ? EducationData.fromJson(data) : null;

  CareerData? get careerData =>
      type == 'career' ? CareerData.fromJson(data) : null;

  ContactData? get contactData =>
      type == 'contact' ? ContactData.fromJson(data) : null;

  AboutData? get aboutData => type == 'about' ? AboutData.fromJson(data) : null;

  AchievementData? get achievementData =>
      type == 'achievement' ? AchievementData.fromJson(data) : null;

  ReferenceData? get referenceData =>
      type == 'reference' ? ReferenceData.fromJson(data) : null;
}

// Proje verisi için model
class ProjectData {
  final List<Project> projects;

  ProjectData({required this.projects});

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      projects:
          (json['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'projects': projects.map((e) => e.toJson()).toList()};
  }
}

class Project {
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

  Project({
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

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      githubUrl: json['githubUrl'],
      playStoreUrl: json['playStoreUrl'],
      appStoreUrl: json['appStoreUrl'],
      webUrl: json['webUrl'],
      demoUrl: json['demoUrl'],
      technologies: List<String>.from(json['technologies'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      status: json['status'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      teamSize: json['teamSize'] ?? 1,
      role: json['role'],
      ownProject: json['ownProject'] ?? true,
      clientName: json['clientName'],
      displayOn: Map<String, bool>.from(json['displayOn'] ?? {}),
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
}

// Diğer veri türleri için basit placeholder sınıfları
class EducationData {
  final Map<String, dynamic> data;
  EducationData({required this.data});
  factory EducationData.fromJson(Map<String, dynamic> json) =>
      EducationData(data: json);
  Map<String, dynamic> toJson() => data;
}

class CareerData {
  final Map<String, dynamic> data;
  CareerData({required this.data});
  factory CareerData.fromJson(Map<String, dynamic> json) =>
      CareerData(data: json);
  Map<String, dynamic> toJson() => data;
}

class ContactData {
  final Map<String, dynamic> data;
  ContactData({required this.data});
  factory ContactData.fromJson(Map<String, dynamic> json) =>
      ContactData(data: json);
  Map<String, dynamic> toJson() => data;
}

class AboutData {
  final Map<String, dynamic> data;
  AboutData({required this.data});
  factory AboutData.fromJson(Map<String, dynamic> json) =>
      AboutData(data: json);
  Map<String, dynamic> toJson() => data;
}

class AchievementData {
  final Map<String, dynamic> data;
  AchievementData({required this.data});
  factory AchievementData.fromJson(Map<String, dynamic> json) =>
      AchievementData(data: json);
  Map<String, dynamic> toJson() => data;
}

class ReferenceData {
  final Map<String, dynamic> data;
  ReferenceData({required this.data});
  factory ReferenceData.fromJson(Map<String, dynamic> json) =>
      ReferenceData(data: json);
  Map<String, dynamic> toJson() => data;
}
