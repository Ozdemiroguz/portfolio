import 'package:equatable/equatable.dart';

/// Portfolio domain entity
/// Pure business logic representation, no JSON dependencies
class PortfolioEntity extends Equatable {
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
  final PortfolioThemeEntity theme;
  final List<SocialLinkEntity> socialLinks;
  final List<String> skills;
  final List<String> tags;
  final List<String> languages;
  final String defaultLocale;

  const PortfolioEntity({
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

class PortfolioThemeEntity extends Equatable {
  final String mode;
  final String primaryColor;
  final String backgroundColor;
  final String textColor;
  final String accentColor;

  const PortfolioThemeEntity({
    required this.mode,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
  });

  @override
  List<Object?> get props => [
        mode,
        primaryColor,
        backgroundColor,
        textColor,
        accentColor,
      ];
}

class SocialLinkEntity extends Equatable {
  final String type;
  final String? url;

  const SocialLinkEntity({
    required this.type,
    this.url,
  });

  @override
  List<Object?> get props => [type, url];
}
