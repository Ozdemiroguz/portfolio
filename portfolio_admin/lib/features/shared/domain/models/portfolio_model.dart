import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'portfolio_model.g.dart';

@JsonSerializable()
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
  final ThemeConfig theme;
  final List<SocialLink> socialLinks;
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

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioModelToJson(this);

  PortfolioModel copyWith({
    String? id,
    String? domain,
    String? title,
    String? description,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    String? customDomain,
    String? coverImage,
    String? profilePhoto,
    String? portfolioType,
    ThemeConfig? theme,
    List<SocialLink>? socialLinks,
    List<String>? skills,
    List<String>? tags,
    List<String>? languages,
    String? defaultLocale,
  }) {
    return PortfolioModel(
      id: id ?? this.id,
      domain: domain ?? this.domain,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      customDomain: customDomain ?? this.customDomain,
      coverImage: coverImage ?? this.coverImage,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      portfolioType: portfolioType ?? this.portfolioType,
      theme: theme ?? this.theme,
      socialLinks: socialLinks ?? this.socialLinks,
      skills: skills ?? this.skills,
      tags: tags ?? this.tags,
      languages: languages ?? this.languages,
      defaultLocale: defaultLocale ?? this.defaultLocale,
    );
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

@JsonSerializable()
class ThemeConfig extends Equatable {
  final String mode;
  final String primaryColor;
  final String backgroundColor;
  final String textColor;
  final String accentColor;

  const ThemeConfig({
    required this.mode,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeConfigToJson(this);

  ThemeConfig copyWith({
    String? mode,
    String? primaryColor,
    String? backgroundColor,
    String? textColor,
    String? accentColor,
  }) {
    return ThemeConfig(
      mode: mode ?? this.mode,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
    );
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

@JsonSerializable()
class SocialLink extends Equatable {
  final String type;
  final String? url;

  const SocialLink({required this.type, this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) =>
      _$SocialLinkFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLinkToJson(this);

  @override
  List<Object?> get props => [type, url];
}
