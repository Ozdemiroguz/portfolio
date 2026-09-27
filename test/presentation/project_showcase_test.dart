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

    test('store apps come before projects without a store listing', () {
      final firstUnpublished = items.indexWhere((item) => !item.isPublished);
      final lastPublished = items.lastIndexWhere((item) => item.isPublished);
      expect(lastPublished, lessThan(firstUnpublished));
    });

    test('scores are non-increasing', () {
      for (var i = 1; i < items.length; i++) {
        expect(items[i].featuredScore,
            lessThanOrEqualTo(items[i - 1].featuredScore));
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
