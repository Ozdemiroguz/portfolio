// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppModel _$AppModelFromJson(Map<String, dynamic> json) => AppModel(
  id: json['id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  isActive: json['isActive'] as bool,
  order: (json['order'] as num).toInt(),
  data: json['data'] as Map<String, dynamic>,
);

Map<String, dynamic> _$AppModelToJson(AppModel instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'icon': instance.icon,
  'images': instance.images,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'isActive': instance.isActive,
  'order': instance.order,
  'data': instance.data,
};

ProjectAppData _$ProjectAppDataFromJson(Map<String, dynamic> json) =>
    ProjectAppData(
      projects:
          (json['projects'] as List<dynamic>)
              .map((e) => ProjectItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ProjectAppDataToJson(ProjectAppData instance) =>
    <String, dynamic>{'projects': instance.projects};

ProjectItem _$ProjectItemFromJson(Map<String, dynamic> json) => ProjectItem(
  title: json['title'] as String,
  description: json['description'] as String,
  githubUrl: json['githubUrl'] as String?,
  playStoreUrl: json['playStoreUrl'] as String?,
  appStoreUrl: json['appStoreUrl'] as String?,
  webUrl: json['webUrl'] as String?,
  demoUrl: json['demoUrl'] as String?,
  technologies:
      (json['technologies'] as List<dynamic>).map((e) => e as String).toList(),
  features:
      (json['features'] as List<dynamic>).map((e) => e as String).toList(),
  status: json['status'] as String,
  startDate:
      json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
  endDate:
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
  teamSize: (json['teamSize'] as num?)?.toInt(),
  role: json['role'] as String?,
  ownProject: json['ownProject'] as bool,
  clientName: json['clientName'] as String?,
  displayOn: Map<String, bool>.from(json['displayOn'] as Map),
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ProjectItemToJson(ProjectItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'githubUrl': instance.githubUrl,
      'playStoreUrl': instance.playStoreUrl,
      'appStoreUrl': instance.appStoreUrl,
      'webUrl': instance.webUrl,
      'demoUrl': instance.demoUrl,
      'technologies': instance.technologies,
      'features': instance.features,
      'status': instance.status,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'teamSize': instance.teamSize,
      'role': instance.role,
      'ownProject': instance.ownProject,
      'clientName': instance.clientName,
      'displayOn': instance.displayOn,
      'images': instance.images,
    };

EducationAppData _$EducationAppDataFromJson(Map<String, dynamic> json) =>
    EducationAppData(
      educations:
          (json['educations'] as List<dynamic>)
              .map((e) => EducationItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$EducationAppDataToJson(EducationAppData instance) =>
    <String, dynamic>{'educations': instance.educations};

EducationItem _$EducationItemFromJson(
  Map<String, dynamic> json,
) => EducationItem(
  institution: json['institution'] as String,
  degree: json['degree'] as String,
  field: json['field'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate:
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
  gpa: (json['gpa'] as num?)?.toDouble(),
  gpaScale: json['gpaScale'] as String?,
  courses: (json['courses'] as List<dynamic>).map((e) => e as String).toList(),
  achievements:
      (json['achievements'] as List<dynamic>).map((e) => e as String).toList(),
  status: json['status'] as String,
  location: json['location'] as String?,
  website: json['website'] as String?,
);

Map<String, dynamic> _$EducationItemToJson(EducationItem instance) =>
    <String, dynamic>{
      'institution': instance.institution,
      'degree': instance.degree,
      'field': instance.field,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'gpa': instance.gpa,
      'gpaScale': instance.gpaScale,
      'courses': instance.courses,
      'achievements': instance.achievements,
      'status': instance.status,
      'location': instance.location,
      'website': instance.website,
    };

CareerAppData _$CareerAppDataFromJson(
  Map<String, dynamic> json,
) => CareerAppData(
  company: json['company'] as String,
  position: json['position'] as String,
  department: json['department'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate:
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
  employmentType: json['employmentType'] as String,
  location: json['location'] as String?,
  website: json['website'] as String?,
  responsibilities:
      (json['responsibilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  achievements:
      (json['achievements'] as List<dynamic>).map((e) => e as String).toList(),
  technologies:
      (json['technologies'] as List<dynamic>).map((e) => e as String).toList(),
  salary: json['salary'] as String?,
  currentJob: json['currentJob'] as bool,
);

Map<String, dynamic> _$CareerAppDataToJson(CareerAppData instance) =>
    <String, dynamic>{
      'company': instance.company,
      'position': instance.position,
      'department': instance.department,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'employmentType': instance.employmentType,
      'location': instance.location,
      'website': instance.website,
      'responsibilities': instance.responsibilities,
      'achievements': instance.achievements,
      'technologies': instance.technologies,
      'salary': instance.salary,
      'currentJob': instance.currentJob,
    };

ContactAppData _$ContactAppDataFromJson(Map<String, dynamic> json) =>
    ContactAppData(
      contactPersons:
          (json['contactPersons'] as List<dynamic>)
              .map((e) => ContactPerson.fromJson(e as Map<String, dynamic>))
              .toList(),
      contactForm:
          json['contactForm'] == null
              ? null
              : ContactForm.fromJson(
                json['contactForm'] as Map<String, dynamic>,
              ),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      socialLinks: Map<String, String>.from(json['socialLinks'] as Map),
      workingHours: json['workingHours'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$ContactAppDataToJson(ContactAppData instance) =>
    <String, dynamic>{
      'contactPersons': instance.contactPersons,
      'contactForm': instance.contactForm,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'socialLinks': instance.socialLinks,
      'workingHours': instance.workingHours,
      'timezone': instance.timezone,
    };

ContactPerson _$ContactPersonFromJson(Map<String, dynamic> json) =>
    ContactPerson(
      name: json['name'] as String,
      position: json['position'] as String?,
      department: json['department'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      linkedin: json['linkedin'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ContactPersonToJson(ContactPerson instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'department': instance.department,
      'email': instance.email,
      'phone': instance.phone,
      'linkedin': instance.linkedin,
      'description': instance.description,
    };

ContactMethod _$ContactMethodFromJson(Map<String, dynamic> json) =>
    ContactMethod(
      type: json['type'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$ContactMethodToJson(ContactMethod instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'value': instance.value,
      'icon': instance.icon,
    };

ContactForm _$ContactFormFromJson(Map<String, dynamic> json) => ContactForm(
  enabled: json['enabled'] as bool,
  submitEndpoint: json['submitEndpoint'] as String?,
  requiredFields:
      (json['requiredFields'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  successMessage: json['successMessage'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$ContactFormToJson(ContactForm instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'submitEndpoint': instance.submitEndpoint,
      'requiredFields': instance.requiredFields,
      'successMessage': instance.successMessage,
      'errorMessage': instance.errorMessage,
    };

AchievementAppData _$AchievementAppDataFromJson(Map<String, dynamic> json) =>
    AchievementAppData(
      category: json['category'] as String,
      issuer: json['issuer'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      expiryDate:
          json['expiryDate'] == null
              ? null
              : DateTime.parse(json['expiryDate'] as String),
      credentialId: json['credentialId'] as String?,
      credentialUrl: json['credentialUrl'] as String?,
      verificationUrl: json['verificationUrl'] as String?,
      level: json['level'] as String,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      score: json['score'] as String?,
      grade: json['grade'] as String?,
    );

Map<String, dynamic> _$AchievementAppDataToJson(AchievementAppData instance) =>
    <String, dynamic>{
      'category': instance.category,
      'issuer': instance.issuer,
      'issueDate': instance.issueDate.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'credentialId': instance.credentialId,
      'credentialUrl': instance.credentialUrl,
      'verificationUrl': instance.verificationUrl,
      'level': instance.level,
      'skills': instance.skills,
      'score': instance.score,
      'grade': instance.grade,
    };

AboutAppData _$AboutAppDataFromJson(Map<String, dynamic> json) => AboutAppData(
  summary: json['summary'] as String,
  mission: json['mission'] as String?,
  vision: json['vision'] as String?,
  interests:
      (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
  hobbies: (json['hobbies'] as List<dynamic>).map((e) => e as String).toList(),
  personalInfo: Map<String, String>.from(json['personalInfo'] as Map),
  languages:
      (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
  cv: json['cv'] as String?,
  portfolio: json['portfolio'] as String?,
);

Map<String, dynamic> _$AboutAppDataToJson(AboutAppData instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'mission': instance.mission,
      'vision': instance.vision,
      'interests': instance.interests,
      'hobbies': instance.hobbies,
      'personalInfo': instance.personalInfo,
      'languages': instance.languages,
      'cv': instance.cv,
      'portfolio': instance.portfolio,
    };

ReferenceAppData _$ReferenceAppDataFromJson(Map<String, dynamic> json) =>
    ReferenceAppData(
      references:
          (json['references'] as List<dynamic>)
              .map((e) => ReferenceItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ReferenceAppDataToJson(ReferenceAppData instance) =>
    <String, dynamic>{'references': instance.references};

ReferenceItem _$ReferenceItemFromJson(Map<String, dynamic> json) =>
    ReferenceItem(
      name: json['name'] as String,
      position: json['position'] as String,
      company: json['company'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      linkedin: json['linkedin'] as String?,
      relationship: json['relationship'] as String,
      recommendation: json['recommendation'] as String?,
      canContact: json['canContact'] as bool,
      workTogether:
          json['workTogether'] == null
              ? null
              : DateTime.parse(json['workTogether'] as String),
    );

Map<String, dynamic> _$ReferenceItemToJson(ReferenceItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'company': instance.company,
      'email': instance.email,
      'phone': instance.phone,
      'linkedin': instance.linkedin,
      'relationship': instance.relationship,
      'recommendation': instance.recommendation,
      'canContact': instance.canContact,
      'workTogether': instance.workTogether?.toIso8601String(),
    };

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) => FolderModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
  color: json['color'] as String,
  appIds: (json['appIds'] as List<dynamic>).map((e) => e as String).toList(),
  order: (json['order'] as num).toInt(),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'appIds': instance.appIds,
      'order': instance.order,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
