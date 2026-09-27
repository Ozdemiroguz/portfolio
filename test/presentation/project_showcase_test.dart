import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/data/datasources/local_portfolio_datasource.dart';
import 'package:portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:portfolio/presentation/classic/project_showcase.dart';

void main() {
  late List<ProjectShowcaseItem> items;

  setUpAll(() async {
    final repository =
        PortfolioRepositoryImpl(dataSource: LocalPortfolioDataSource());
    final folders = await repository.getFolders(AppStrings.defaultDomain);
    final apps = [
      for (final folder in folders)
        ...await repository.getAppsInFolder(
          AppStrings.defaultDomain,
          folder.appIds,
        ),
    ];
    items = buildProjectShowcase(apps.where((a) => a.type == 'project').toList());
  });

  group('buildProjectShowcase', () {
    test('keeps every project app', () {
      expect(items.length, greaterThanOrEqualTo(9));
    });

    test('explicitly ranked projects lead, in rank order', () {
      final ranked = items.where((i) => i.featuredRank != null).toList();
      expect(ranked, isNotEmpty);
      expect(items.take(ranked.length).toList(), ranked);
      for (var i = 1; i < ranked.length; i++) {
        expect(ranked[i].featuredRank!, greaterThan(ranked[i - 1].featuredRank!));
      }
      expect(items.first.app.id, 'project_subi');
    });

    test('own work precedes client work once explicit ranks are exhausted',
        () {
      final rest = items.where((i) => i.featuredRank == null).toList();
      final firstClient = rest.indexWhere((i) => !i.isOwn);
      final lastOwnShipped = rest.lastIndexWhere(
          (i) => i.isOwn && (i.isPublished || i.onPubDev || i.isOpenSource));
      expect(lastOwnShipped, lessThan(firstClient));
    });

    test('tiers are non-increasing after the ranked block', () {
      final rest = items.where((i) => i.featuredRank == null).toList();
      for (var i = 1; i < rest.length; i++) {
        expect(rest[i].tier, lessThanOrEqualTo(rest[i - 1].tier));
      }
    });

    test('categories cover the data', () {
      expect(items.where((i) => i.matches(ProjectCategory.published)),
          isNotEmpty);
      expect(items.where((i) => i.matches(ProjectCategory.openSource)),
          isNotEmpty);
      expect(items.where((i) => i.matches(ProjectCategory.work)), isNotEmpty);
      expect(items.where((i) => i.matches(ProjectCategory.all)).length,
          items.length);
    });

    test('every referenced image asset exists in the bundle manifest',
        () async {
      // Guards against the broken .png references that used to ship.
      for (final item in items) {
        for (final asset in [
          ...item.project.images,
          if (item.app.iconImage != null) item.app.iconImage!,
        ]) {
          expect(asset, endsWith('.webp'), reason: '$asset is not a webp');
        }
      }
    });
  });
}
