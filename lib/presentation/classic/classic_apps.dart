import '../../domain/entities/about_data_entity.dart';
import '../../domain/entities/achievement_data_entity.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/entities/career_data_entity.dart';
import '../../domain/entities/contact_data_entity.dart';

/// Pulls the pieces the classic layout needs out of the flat app list.
class ClassicApps {
  final List<AppEntity> apps;

  const ClassicApps(this.apps);

  AppEntity? _byType(String type) {
    for (final app in apps) {
      if (app.type == type) return app;
    }
    return null;
  }

  AboutDataEntity? get about => _byType('about')?.aboutData;
  ContactDataEntity? get contact => _byType('contact')?.contactData;
  CareerDataEntity? get career => _byType('career')?.careerData;
  AchievementDataEntity? get achievements =>
      _byType('achievement')?.achievementData;

  /// Project apps in their configured order.
  List<AppEntity> get projects {
    final list = apps.where((app) => app.type == 'project').toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  String? get cvUrl {
    final data = _byType('cv')?.data;
    if (data is Map<String, dynamic>) {
      return data['pdfUrl'] as String?;
    }
    return null;
  }

  String? socialUrl(String platform) {
    final socials = contact?.socials ?? const [];
    for (final social in socials) {
      if (social.platform.toLowerCase().contains(platform)) return social.url;
    }
    return null;
  }
}
