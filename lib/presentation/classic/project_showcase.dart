import '../../domain/entities/app_entity.dart';
import '../../domain/entities/project_data_entity.dart';

/// Filter buckets for the projects section.
enum ProjectCategory { all, published, openSource, work }

/// A project app paired with the facts the showcase cards need.
class ProjectShowcaseItem {
  final AppEntity app;
  final ProjectEntity project;

  const ProjectShowcaseItem({required this.app, required this.project});

  static ProjectShowcaseItem? from(AppEntity app) {
    final project = app.projectData?.projects.firstOrNull;
    if (project == null) return null;
    return ProjectShowcaseItem(app: app, project: project);
  }

  bool get onAppStore => _has(project.appStoreUrl);
  bool get onPlayStore => _has(project.playStoreUrl);
  bool get isPublished => onAppStore || onPlayStore;
  bool get isOpenSource => _has(project.githubUrl);
  bool get isWork => !project.ownProject;
  bool get hasWebsite => _has(project.webUrl);

  /// A demo link; an `.apk` URL is offered as a direct download.
  bool get hasDemo => _has(project.demoUrl);
  bool get demoIsApk => project.demoUrl?.toLowerCase().endsWith('.apk') ?? false;

  bool matches(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.all:
        return true;
      case ProjectCategory.published:
        return isPublished;
      case ProjectCategory.openSource:
        return isOpenSource;
      case ProjectCategory.work:
        return isWork;
    }
  }

  /// Published on pub.dev (Flutter/Dart package).
  bool get onPubDev => project.webUrl?.startsWith('https://pub.dev/') ?? false;

  bool get isOwn => project.ownProject;

  /// Explicit showcase position from the data, if any.
  int? get featuredRank => project.featuredRank;

  /// Tier for the automatic ordering: the owner's own shipped apps and
  /// packages first, then own open source, then client work.
  int get tier {
    if (isOwn && isPublished) return 6;
    if (isOwn && onPubDev) return 5;
    if (isOwn && isOpenSource) return 4;
    if (isPublished) return 3;
    if (isOpenSource) return 2;
    return isOwn ? 1 : 0;
  }

  /// Tie-breaker within a tier: more channels and visuals rank higher.
  int get featuredScore =>
      (onAppStore ? 4 : 0) +
      (onPlayStore ? 4 : 0) +
      (onPubDev ? 3 : 0) +
      (isOpenSource ? 2 : 0) +
      (hasWebsite ? 1 : 0) +
      (project.images.isNotEmpty ? 1 : 0);

  static bool _has(String? url) => url != null && url.trim().isNotEmpty;
}

/// Builds showcase items in featured order (stable for equal scores).
List<ProjectShowcaseItem> buildProjectShowcase(List<AppEntity> apps) {
  final items = <ProjectShowcaseItem>[];
  for (final app in apps) {
    final item = ProjectShowcaseItem.from(app);
    if (item != null) items.add(item);
  }
  final indexed = items.asMap().entries.toList()
    ..sort((a, b) {
      // 1. Explicit featuredRank (ascending) beats everything.
      final ra = a.value.featuredRank;
      final rb = b.value.featuredRank;
      if (ra != null || rb != null) {
        if (ra == null) return 1;
        if (rb == null) return -1;
        if (ra != rb) return ra.compareTo(rb);
      }
      // 2. Tier, 3. score, 4. data order.
      final byTier = b.value.tier.compareTo(a.value.tier);
      if (byTier != 0) return byTier;
      final byScore = b.value.featuredScore.compareTo(a.value.featuredScore);
      return byScore != 0 ? byScore : a.key.compareTo(b.key);
    });
  return [for (final entry in indexed) entry.value];
}
