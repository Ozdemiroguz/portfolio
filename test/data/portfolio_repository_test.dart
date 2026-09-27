import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/data/datasources/local_portfolio_datasource.dart';
import 'package:portfolio/data/repositories/portfolio_repository_impl.dart';

void main() {
  late PortfolioRepositoryImpl repository;

  setUp(() {
    repository = PortfolioRepositoryImpl(dataSource: LocalPortfolioDataSource());
  });

  group('PortfolioRepositoryImpl', () {
    test('returns the portfolio for the default domain', () async {
      final portfolio = await repository.getPortfolio(AppStrings.defaultDomain);

      expect(portfolio, isNotNull);
      expect(portfolio!.domain, AppStrings.defaultDomain);
      expect(portfolio.title, isNotEmpty);
    });

    test('returns null for an unknown domain', () async {
      final portfolio = await repository.getPortfolio('does-not-exist');

      expect(portfolio, isNull);
    });

    test('home and dock apps are populated with unique ids', () async {
      final homeApps = await repository.getHomeApps(AppStrings.defaultDomain);
      final dockApps = await repository.getBottomApps(AppStrings.defaultDomain);

      expect(homeApps, isNotEmpty);
      expect(dockApps, isNotEmpty);

      final ids = [...homeApps, ...dockApps].map((app) => app.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'app ids must be unique');
    });

    test('every folder resolves to its active apps', () async {
      final folders = await repository.getFolders(AppStrings.defaultDomain);

      expect(folders, isNotEmpty);
      for (final folder in folders) {
        final apps = await repository.getAppsInFolder(
          AppStrings.defaultDomain,
          folder.appIds,
        );
        // Folders may list apps that are switched off with isActive: false,
        // so only require that what comes back belongs to the folder and
        // that the folder is not empty.
        expect(apps, isNotEmpty,
            reason: 'folder "${folder.title}" resolves to no apps');
        for (final app in apps) {
          expect(folder.appIds, contains(app.id),
              reason: 'folder "${folder.title}" returned a foreign app');
        }
      }
    });
  });
}
