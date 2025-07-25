// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioModel _$PortfolioModelFromJson(Map<String, dynamic> json) =>
    PortfolioModel(
      id: json['id'] as String,
      domain: json['domain'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPublic: json['isPublic'] as bool,
      customDomain: json['customDomain'] as String?,
      coverImage: json['coverImage'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      portfolioType: json['portfolioType'] as String,
      theme: ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>),
      socialLinks:
          (json['socialLinks'] as List<dynamic>)
              .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
              .toList(),
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      defaultLocale: json['defaultLocale'] as String,
    );

Map<String, dynamic> _$PortfolioModelToJson(PortfolioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'domain': instance.domain,
      'title': instance.title,
      'description': instance.description,
      'ownerId': instance.ownerId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isPublic': instance.isPublic,
      'customDomain': instance.customDomain,
      'coverImage': instance.coverImage,
      'profilePhoto': instance.profilePhoto,
      'portfolioType': instance.portfolioType,
      'theme': instance.theme,
      'socialLinks': instance.socialLinks,
      'skills': instance.skills,
      'tags': instance.tags,
      'languages': instance.languages,
      'defaultLocale': instance.defaultLocale,
    };

ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => ThemeConfig(
  mode: json['mode'] as String,
  primaryColor: json['primaryColor'] as String,
  backgroundColor: json['backgroundColor'] as String,
  textColor: json['textColor'] as String,
  accentColor: json['accentColor'] as String,
);

Map<String, dynamic> _$ThemeConfigToJson(ThemeConfig instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'primaryColor': instance.primaryColor,
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'accentColor': instance.accentColor,
    };

SocialLink _$SocialLinkFromJson(Map<String, dynamic> json) =>
    SocialLink(type: json['type'] as String, url: json['url'] as String?);

Map<String, dynamic> _$SocialLinkToJson(SocialLink instance) =>
    <String, dynamic>{'type': instance.type, 'url': instance.url};
