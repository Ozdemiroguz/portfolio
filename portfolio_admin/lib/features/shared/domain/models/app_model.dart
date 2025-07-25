import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'app_model.g.dart';

// Base App Model - Tüm app türleri için ortak alanlar
@JsonSerializable()
class AppModel extends Equatable {
  final String id;
  final String
  type; // project, about, education, contact, career, achievement, reference, etc.
  final String title;
  final String description;
  final String icon;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int order;
  final Map<String, dynamic> data; // Type-specific data

  const AppModel({
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

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);
  Map<String, dynamic> toJson() => _$AppModelToJson(this);

  AppModel copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? icon,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    int? order,
    Map<String, dynamic>? data,
  }) {
    return AppModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    description,
    icon,
    images,
    createdAt,
    updatedAt,
    isActive,
    order,
    data,
  ];
}

// Project App Data Model - Supports up to 10 projects
@JsonSerializable()
class ProjectAppData extends Equatable {
  final List<ProjectItem> projects; // Max 10 projects

  const ProjectAppData({required this.projects});

  factory ProjectAppData.fromJson(Map<String, dynamic> json) =>
      _$ProjectAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectAppDataToJson(this);

  @override
  List<Object?> get props => [projects];
}

@JsonSerializable()
class ProjectItem extends Equatable {
  final String title;
  final String description;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? webUrl;
  final String? demoUrl;
  final List<String> technologies;
  final List<String> features;
  final String status; // completed, in-progress, planned
  final DateTime? startDate;
  final DateTime? endDate;
  final int? teamSize;
  final String? role;
  final bool ownProject;
  final String? clientName;
  final Map<String, bool> displayOn; // playStore, appStore, github, web
  final List<String> images; // Project images

  const ProjectItem({
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
    this.teamSize,
    this.role,
    required this.ownProject,
    this.clientName,
    required this.displayOn,
    required this.images,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) =>
      _$ProjectItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectItemToJson(this);

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

// Education App Data Model - List of education items
@JsonSerializable()
class EducationAppData extends Equatable {
  final List<EducationItem> educations; // List of educational background

  const EducationAppData({required this.educations});

  factory EducationAppData.fromJson(Map<String, dynamic> json) =>
      _$EducationAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$EducationAppDataToJson(this);

  @override
  List<Object?> get props => [educations];
}

@JsonSerializable()
class EducationItem extends Equatable {
  final String institution;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;
  final String? gpaScale;
  final List<String> courses;
  final List<String> achievements;
  final String status; // completed, ongoing, paused
  final String? location;
  final String? website;

  const EducationItem({
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.gpa,
    this.gpaScale,
    required this.courses,
    required this.achievements,
    required this.status,
    this.location,
    this.website,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) =>
      _$EducationItemFromJson(json);
  Map<String, dynamic> toJson() => _$EducationItemToJson(this);

  @override
  List<Object?> get props => [
    institution,
    degree,
    field,
    startDate,
    endDate,
    gpa,
    gpaScale,
    courses,
    achievements,
    status,
    location,
    website,
  ];
}

// Career App Data Model
@JsonSerializable()
class CareerAppData extends Equatable {
  final String company;
  final String position;
  final String department;
  final DateTime startDate;
  final DateTime? endDate;
  final String employmentType; // full-time, part-time, contract, internship
  final String? location;
  final String? website;
  final List<String> responsibilities;
  final List<String> achievements;
  final List<String> technologies;
  final String? salary;
  final bool currentJob;

  const CareerAppData({
    required this.company,
    required this.position,
    required this.department,
    required this.startDate,
    this.endDate,
    required this.employmentType,
    this.location,
    this.website,
    required this.responsibilities,
    required this.achievements,
    required this.technologies,
    this.salary,
    required this.currentJob,
  });

  factory CareerAppData.fromJson(Map<String, dynamic> json) =>
      _$CareerAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$CareerAppDataToJson(this);

  @override
  List<Object?> get props => [
    company,
    position,
    department,
    startDate,
    endDate,
    employmentType,
    location,
    website,
    responsibilities,
    achievements,
    technologies,
    salary,
    currentJob,
  ];
}

// Contact App Data Model - Enhanced with contact persons
@JsonSerializable()
class ContactAppData extends Equatable {
  final List<ContactPerson> contactPersons; // List of contact persons
  final ContactForm? contactForm;
  final String? address;
  final String? phone;
  final String? email;
  final Map<String, String> socialLinks;
  final String? workingHours;
  final String? timezone;

  const ContactAppData({
    required this.contactPersons,
    this.contactForm,
    this.address,
    this.phone,
    this.email,
    required this.socialLinks,
    this.workingHours,
    this.timezone,
  });

  factory ContactAppData.fromJson(Map<String, dynamic> json) =>
      _$ContactAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContactAppDataToJson(this);

  @override
  List<Object?> get props => [
    contactPersons,
    contactForm,
    address,
    phone,
    email,
    socialLinks,
    workingHours,
    timezone,
  ];
}

@JsonSerializable()
class ContactPerson extends Equatable {
  final String name;
  final String? position;
  final String? department;
  final String? email;
  final String? phone;
  final String? linkedin;
  final String? description;

  const ContactPerson({
    required this.name,
    this.position,
    this.department,
    this.email,
    this.phone,
    this.linkedin,
    this.description,
  });

  factory ContactPerson.fromJson(Map<String, dynamic> json) =>
      _$ContactPersonFromJson(json);
  Map<String, dynamic> toJson() => _$ContactPersonToJson(this);

  @override
  List<Object?> get props => [
    name,
    position,
    department,
    email,
    phone,
    linkedin,
    description,
  ];
}

@JsonSerializable()
class ContactMethod extends Equatable {
  final String type; // email, phone, social, address
  final String label;
  final String value;
  final String? icon;

  const ContactMethod({
    required this.type,
    required this.label,
    required this.value,
    this.icon,
  });

  factory ContactMethod.fromJson(Map<String, dynamic> json) =>
      _$ContactMethodFromJson(json);
  Map<String, dynamic> toJson() => _$ContactMethodToJson(this);

  @override
  List<Object?> get props => [type, label, value, icon];
}

@JsonSerializable()
class ContactForm extends Equatable {
  final bool enabled;
  final String? submitEndpoint;
  final List<String> requiredFields;
  final String? successMessage;
  final String? errorMessage;

  const ContactForm({
    required this.enabled,
    this.submitEndpoint,
    required this.requiredFields,
    this.successMessage,
    this.errorMessage,
  });

  factory ContactForm.fromJson(Map<String, dynamic> json) =>
      _$ContactFormFromJson(json);
  Map<String, dynamic> toJson() => _$ContactFormToJson(this);

  @override
  List<Object?> get props => [
    enabled,
    submitEndpoint,
    requiredFields,
    successMessage,
    errorMessage,
  ];
}

// Achievement App Data Model
@JsonSerializable()
class AchievementAppData extends Equatable {
  final String category; // award, certificate, recognition, competition
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialId;
  final String? credentialUrl;
  final String? verificationUrl;
  final String level; // beginner, intermediate, advanced, expert
  final List<String> skills;
  final String? score;
  final String? grade;

  const AchievementAppData({
    required this.category,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
    this.verificationUrl,
    required this.level,
    required this.skills,
    this.score,
    this.grade,
  });

  factory AchievementAppData.fromJson(Map<String, dynamic> json) =>
      _$AchievementAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementAppDataToJson(this);

  @override
  List<Object?> get props => [
    category,
    issuer,
    issueDate,
    expiryDate,
    credentialId,
    credentialUrl,
    verificationUrl,
    level,
    skills,
    score,
    grade,
  ];
}

// About App Data Model
@JsonSerializable()
class AboutAppData extends Equatable {
  final String summary;
  final String? mission;
  final String? vision;
  final List<String> interests;
  final List<String> hobbies;
  final Map<String, String> personalInfo; // age, location, etc.
  final List<String> languages;
  final String? cv;
  final String? portfolio;

  const AboutAppData({
    required this.summary,
    this.mission,
    this.vision,
    required this.interests,
    required this.hobbies,
    required this.personalInfo,
    required this.languages,
    this.cv,
    this.portfolio,
  });

  factory AboutAppData.fromJson(Map<String, dynamic> json) =>
      _$AboutAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AboutAppDataToJson(this);

  @override
  List<Object?> get props => [
    summary,
    mission,
    vision,
    interests,
    hobbies,
    personalInfo,
    languages,
    cv,
    portfolio,
  ];
}

// Reference App Data Model - List of references
@JsonSerializable()
class ReferenceAppData extends Equatable {
  final List<ReferenceItem> references; // List of references

  const ReferenceAppData({required this.references});

  factory ReferenceAppData.fromJson(Map<String, dynamic> json) =>
      _$ReferenceAppDataFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceAppDataToJson(this);

  @override
  List<Object?> get props => [references];
}

@JsonSerializable()
class ReferenceItem extends Equatable {
  final String name;
  final String position;
  final String company;
  final String? email;
  final String? phone;
  final String? linkedin;
  final String relationship; // colleague, manager, client, mentor
  final String? recommendation;
  final bool canContact;
  final DateTime? workTogether;

  const ReferenceItem({
    required this.name,
    required this.position,
    required this.company,
    this.email,
    this.phone,
    this.linkedin,
    required this.relationship,
    this.recommendation,
    required this.canContact,
    this.workTogether,
  });

  factory ReferenceItem.fromJson(Map<String, dynamic> json) =>
      _$ReferenceItemFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceItemToJson(this);

  @override
  List<Object?> get props => [
    name,
    position,
    company,
    email,
    phone,
    linkedin,
    relationship,
    recommendation,
    canContact,
    workTogether,
  ];
}

// Folder Model
@JsonSerializable()
class FolderModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final List<String> appIds;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FolderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.appIds,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
  Map<String, dynamic> toJson() => _$FolderModelToJson(this);

  FolderModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? color,
    List<String>? appIds,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FolderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      appIds: appIds ?? this.appIds,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    color,
    appIds,
    order,
    isActive,
    createdAt,
    updatedAt,
  ];
}
