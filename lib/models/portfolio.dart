// Helper method to parse DateTime
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is String) return DateTime.parse(value);
  if (value is DateTime) return value;
  return DateTime.now();
}

class Portfolio {
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
  final ThemeData theme;
  final List<SocialLink> socialLinks;
  final List<String> skills;
  final List<String> tags;
  final List<String> languages;
  final String defaultLocale;

  Portfolio({
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

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] ?? '',
      domain: json['domain'] ?? '',
      title: json['title'] ?? 'Portfolio',
      description: json['description'] ?? 'Açıklama bulunamadı',
      ownerId: json['ownerId'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      isPublic: json['isPublic'] ?? true,
      customDomain: json['customDomain'],
      coverImage: json['coverImage'],
      profilePhoto: json['profilePhoto'],
      portfolioType: json['portfolioType'] ?? 'mobile',
      theme:
          json['theme'] != null
              ? ThemeData.fromJson(json['theme'])
              : ThemeData(
                mode: 'dark',
                primaryColor: '#2196F3',
                backgroundColor: '#121212',
                textColor: '#FFFFFF',
                accentColor: '#FF4081',
              ),
      socialLinks:
          json['socialLinks'] != null
              ? (json['socialLinks'] as List)
                  .map((e) => SocialLink.fromJson(e))
                  .toList()
              : [],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      languages:
          json['languages'] != null
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
}

class ThemeData {
  final String mode;
  final String primaryColor;
  final String backgroundColor;
  final String textColor;
  final String accentColor;

  ThemeData({
    required this.mode,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
  });

  factory ThemeData.fromJson(Map<String, dynamic> json) {
    return ThemeData(
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
}

class SocialLink {
  final String type;
  final String? url;

  SocialLink({required this.type, this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(type: json['type'] ?? 'unknown', url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'url': url};
  }
}
