import 'package:flutter/foundation.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/entities/folder_entity.dart';
import '../../domain/entities/about_data_entity.dart';
import '../../domain/entities/career_data_entity.dart';
import '../../domain/entities/contact_data_entity.dart' as contact;
import '../../domain/entities/project_data_entity.dart';
import '../../domain/entities/achievement_data_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_datasource.dart';
import '../models/portfolio_model.dart';
import '../models/app_model.dart';
import '../models/folder_model.dart';

/// Portfolio repository implementation
/// Maps data models to domain entities
class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioDataSource dataSource;

  const PortfolioRepositoryImpl({required this.dataSource});

  @override
  Future<PortfolioEntity?> getPortfolio(String domain) async {
    final model = await dataSource.getPortfolio(domain);
    return model != null ? _mapPortfolioModelToEntity(model) : null;
  }

  @override
  Future<List<FolderEntity>> getFolders(String domain) async {
    final models = await dataSource.getFolders(domain);
    return models.map(_mapFolderModelToEntity).toList();
  }

  @override
  Future<List<AppEntity>> getHomeApps(String domain) async {
    final models = await dataSource.getHomeApps(domain);
    return models.map(_mapAppModelToEntity).toList();
  }

  @override
  Future<List<AppEntity>> getBottomApps(String domain) async {
    final models = await dataSource.getBottomApps(domain);
    return models.map(_mapAppModelToEntity).toList();
  }

  @override
  Future<List<AppEntity>> getAppsInFolder(
    String domain,
    List<String> appIds,
  ) async {
    final models = await dataSource.getAppsInFolder(domain, appIds);
    return models.map(_mapAppModelToEntity).toList();
  }

  @override
  Future<bool> sendContactMessage(
    String portfolioId,
    String email,
    String title,
    String message,
  ) async {
    return await dataSource.sendContactMessage(
      portfolioId,
      email,
      title,
      message,
    );
  }

  // Mapper functions: Model -> Entity

  PortfolioEntity _mapPortfolioModelToEntity(PortfolioModel model) {
    return PortfolioEntity(
      id: model.id,
      domain: model.domain,
      title: model.title,
      description: model.description,
      ownerId: model.ownerId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isPublic: model.isPublic,
      customDomain: model.customDomain,
      coverImage: model.coverImage,
      profilePhoto: model.profilePhoto,
      portfolioType: model.portfolioType,
      theme: _mapThemeModelToEntity(model.theme),
      socialLinks:
          model.socialLinks.map(_mapSocialLinkModelToEntity).toList(),
      skills: model.skills,
      tags: model.tags,
      languages: model.languages,
      defaultLocale: model.defaultLocale,
    );
  }

  PortfolioThemeEntity _mapThemeModelToEntity(PortfolioThemeModel model) {
    return PortfolioThemeEntity(
      mode: model.mode,
      primaryColor: model.primaryColor,
      backgroundColor: model.backgroundColor,
      textColor: model.textColor,
      accentColor: model.accentColor,
    );
  }

  SocialLinkEntity _mapSocialLinkModelToEntity(SocialLinkModel model) {
    return SocialLinkEntity(
      type: model.type,
      url: model.url,
    );
  }

  FolderEntity _mapFolderModelToEntity(FolderModel model) {
    return FolderEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      icon: model.icon,
      color: model.color,
      appIds: model.appIds,
      order: model.order,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  AppEntity _mapAppModelToEntity(AppModel model) {
    // Debug for gallery
    if (model.type == 'gallery') {
      debugPrint('Gallery model.data: ${model.data}');
      debugPrint('Gallery model.data keys: ${model.data.keys}');
    }
    
    final typedData = _mapAppData(model.type, model.data);

    return AppEntity(
      id: model.id,
      type: model.type,
      title: model.title,
      description: model.description,
      icon: model.icon,
      iconImage: model.iconImage,
      images: model.images,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isActive: model.isActive,
      order: model.order,
      data: typedData,
      titleKey: model.titleKey,
      descriptionKey: model.descriptionKey,
    );
  }

  /// Map app data based on type
  Object? _mapAppData(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'about':
        return _mapAboutData(data);
      case 'career':
        return _mapCareerData(data);
      case 'contact':
        return _mapContactData(data);
      case 'project':
        return _mapProjectData(data);
      case 'achievement':
        return _mapAchievementData(data);
      case 'gallery':
      case 'cv':
        // Return raw data as Map for gallery and cv
        debugPrint('Gallery/CV - mapping data: $data');
        debugPrint('Gallery/CV - data keys: ${data.keys}');
        return data;
      default:
        return data; // Return raw data for unknown types
    }
  }

  AboutDataEntity _mapAboutData(Map<String, dynamic> data) {
    return AboutDataEntity(
      fullName: data['fullName'] as String? ?? '',
      title: data['title'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      location: data['location'] as String? ?? '',
      birthDate: data['birthDate'] as String? ?? '',
      education: data['education'] as String? ?? '',
      interests: (data['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      profileImage: data['profileImage'] as String? ?? 'assets/images/my_photo.webp',
      // Translation keys (optional)
      fullNameKey: data['fullNameKey'] as String?,
      titleKey: data['titleKey'] as String?,
      bioKey: data['bioKey'] as String?,
      locationKey: data['locationKey'] as String?,
      birthDateKey: data['birthDateKey'] as String?,
      educationKey: data['educationKey'] as String?,
      interestsKeys: (data['interestsKeys'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }

  CareerDataEntity _mapCareerData(Map<String, dynamic> data) {
    final experiences = (data['experiences'] as List<dynamic>?)
            ?.map((e) => _mapExperience(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CareerDataEntity(experiences: experiences);
  }

  ExperienceEntity _mapExperience(Map<String, dynamic> data) {
    return ExperienceEntity(
      company: data['company'] as String? ?? '',
      position: data['position'] as String? ?? '',
      startDate: data['startDate'] as String? ?? '',
      endDate: data['endDate'] as String?,
      description: data['description'] as String? ?? '',
      technologies: (data['technologies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      // Translation keys (optional)
      companyKey: data['companyKey'] as String?,
      positionKey: data['positionKey'] as String?,
      descriptionKey: data['descriptionKey'] as String?,
      technologiesKeys: (data['technologiesKeys'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }

  contact.ContactDataEntity _mapContactData(Map<String, dynamic> data) {
    final socials = (data['socials'] as List<dynamic>?)
            ?.map((e) => _mapSocialLink(e as Map<String, dynamic>))
            .toList() ??
        [];

    return contact.ContactDataEntity(
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      socials: socials,
    );
  }

  contact.SocialLinkEntity _mapSocialLink(Map<String, dynamic> data) {
    return contact.SocialLinkEntity(
      platform: data['platform'] as String? ?? '',
      url: data['url'] as String? ?? '',
    );
  }

  ProjectDataEntity _mapProjectData(Map<String, dynamic> data) {
    final projects = (data['projects'] as List<dynamic>?)
            ?.map((e) => _mapProject(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ProjectDataEntity(projects: projects);
  }

  ProjectEntity _mapProject(Map<String, dynamic> data) {
    return ProjectEntity(
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      githubUrl: data['githubUrl'] as String?,
      playStoreUrl: data['playStoreUrl'] as String?,
      appStoreUrl: data['appStoreUrl'] as String?,
      linkedinUrl: data['linkedinUrl'] as String?,
      webUrl: data['webUrl'] as String?,
      demoUrl: data['demoUrl'] as String?,
      technologies: (data['technologies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      features: (data['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: data['status'] as String? ?? '',
      startDate: data['startDate'] as String? ?? '',
      endDate: data['endDate'] as String?,
      teamSize: data['teamSize'] as int?,
      role: data['role'] as String?,
      ownProject: data['ownProject'] as bool? ?? false,
      clientName: data['clientName'] as String?,
      images: (data['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      // Translation keys (optional)
      titleKey: data['titleKey'] as String?,
      descriptionKey: data['descriptionKey'] as String?,
      technologiesKeys: (data['technologiesKeys'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      featuresKeys: (data['featuresKeys'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      roleKey: data['roleKey'] as String?,
      clientNameKey: data['clientNameKey'] as String?,
    );
  }

  AchievementDataEntity _mapAchievementData(Map<String, dynamic> data) {
    final achievements = (data['achievements'] as List<dynamic>?)
            ?.map((e) => _mapAchievement(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AchievementDataEntity(
      achievements: achievements,
      profileImage: data['profileImage'] as String? ?? 'assets/images/my_photo.webp',
    );
  }

  AchievementEntity _mapAchievement(Map<String, dynamic> data) {
    return AchievementEntity(
      title: data['title'] as String? ?? '',
      date: data['date'] as String? ?? '',
      description: data['description'] as String? ?? '',
      issuer: data['issuer'] as String? ?? '',
      // Translation keys (optional)
      titleKey: data['titleKey'] as String?,
      descriptionKey: data['descriptionKey'] as String?,
      issuerKey: data['issuerKey'] as String?,
    );
  }
}
