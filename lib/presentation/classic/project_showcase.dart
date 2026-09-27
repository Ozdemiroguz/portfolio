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

  /// Higher scores surface first: shipped store apps, then open source.
  int get featuredScore =>
      (onAppStore ? 2 : 0) +
      (onPlayStore ? 2 : 0) +
      (isOpenSource ? 1 : 0) +
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
      final byScore = b.value.featuredScore.compareTo(a.value.featuredScore);
      return byScore != 0 ? byScore : a.key.compareTo(b.key);
    });
  return [for (final entry in indexed) entry.value];
}
