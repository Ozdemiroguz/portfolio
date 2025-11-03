import 'package:equatable/equatable.dart';
import '../../core/utils/date_helpers.dart';

/// Portfolio data model
/// Used for data transfer and JSON serialization
class PortfolioModel extends Equatable {
  final String id;
  final String domain;
  final String title;
  final String description;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final String? customDomain;
  final String? coverImage;
  final String? profilePhoto;
  final String portfolioType;
  final PortfolioThemeModel theme;
  final List<SocialLinkModel> socialLinks;
  final List<String> skills;
  final List<String> tags;
  final List<String> languages;
  final String defaultLocale;

  const PortfolioModel({
    required this.id,
    required this.domain,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublic,
    this.customDomain,
    this.coverImage,
    this.profilePhoto,
    required this.portfolioType,
    required this.theme,
    required this.socialLinks,
    required this.skills,
    required this.tags,
    required this.languages,
    required this.defaultLocale,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'] ?? '',
      domain: json['domain'] ?? '',
      title: json['title'] ?? 'Portfolio',
      description: json['description'] ?? 'No description available',
      ownerId: json['ownerId'] ?? '',
      createdAt: DateHelpers.parseDateTime(json['createdAt']),
      updatedAt: DateHelpers.parseDateTime(json['updatedAt']),
      isPublic: json['isPublic'] ?? true,
      customDomain: json['customDomain'],
      coverImage: json['coverImage'],
      profilePhoto: json['profilePhoto'],
      portfolioType: json['portfolioType'] ?? 'mobile',
      theme: json['theme'] != null
          ? PortfolioThemeModel.fromJson(json['theme'])
          : const PortfolioThemeModel(
              mode: 'dark',
              primaryColor: '#2196F3',
              backgroundColor: '#121212',
              textColor: '#FFFFFF',
              accentColor: '#FF4081',
            ),
      socialLinks: json['socialLinks'] != null
          ? (json['socialLinks'] as List)
              .map((e) => SocialLinkModel.fromJson(e))
              .toList()
          : [],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : ['tr'],
      defaultLocale: json['defaultLocale'] ?? 'tr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain': domain,
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublic': isPublic,
      'customDomain': customDomain,
      'coverImage': coverImage,
      'profilePhoto': profilePhoto,
      'portfolioType': portfolioType,
      'theme': theme.toJson(),
      'socialLinks': socialLinks.map((e) => e.toJson()).toList(),
      'skills': skills,
      'tags': tags,
      'languages': languages,
      'defaultLocale': defaultLocale,
    };
  }

  @override
  List<Object?> get props => [
        id,
        domain,
        title,
        description,
        ownerId,
        createdAt,
        updatedAt,
        isPublic,
        customDomain,
        coverImage,
        profilePhoto,
        portfolioType,
        theme,
        socialLinks,
        skills,
        tags,
        languages,
        defaultLocale,
      ];
}

class PortfolioThemeModel extends Equatable {
  final String mode;
  final String primaryColor;
  final String backgroundColor;
  final String textColor;
  final String accentColor;

  const PortfolioThemeModel({
    required this.mode,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
  });

  factory PortfolioThemeModel.fromJson(Map<String, dynamic> json) {
    return PortfolioThemeModel(
      mode: json['mode'] ?? 'dark',
      primaryColor: json['primaryColor'] ?? '#2196F3',
      backgroundColor: json['backgroundColor'] ?? '#121212',
      textColor: json['textColor'] ?? '#FFFFFF',
      accentColor: json['accentColor'] ?? '#FF4081',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'primaryColor': primaryColor,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'accentColor': accentColor,
    };
  }

  @override
  List<Object?> get props => [
        mode,
        primaryColor,
        backgroundColor,
        textColor,
        accentColor,
      ];
}

class SocialLinkModel extends Equatable {
  final String type;
  final String? url;

  const SocialLinkModel({
    required this.type,
    this.url,
  });

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      type: json['type'] ?? 'unknown',
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [type, url];
}
