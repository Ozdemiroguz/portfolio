import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/data/datasources/local_portfolio_datasource.dart';

void main() {
  final dataSource = LocalPortfolioDataSource();

  test('open source folder is exposed with both packages', () async {
    final folders = await dataSource.getFolders('oguz');
    final openSource = folders.firstWhere((f) => f.id == 'folder_open_source');

    expect(openSource.title, 'Open Source');
    expect(openSource.appIds, [
      'package_documentscan',
      'package_imagecompressor',
    ]);

    final apps = await dataSource.getAppsInFolder('oguz', openSource.appIds);
    expect(
      apps.map((a) => a.id),
      ['package_documentscan', 'package_imagecompressor'],
      reason: 'folder appIds must resolve to real cards, otherwise the '
          'datasource silently returns an empty list',
    );
  });

  test('package cards carry pub.dev links and matching feature keys', () async {
    final apps = await dataSource.getAppsInFolder('oguz', [
      'package_documentscan',
      'package_imagecompressor',
    ]);

    for (final app in apps) {
      final project =
          (app.data['projects'] as List).first as Map<String, dynamic>;

      expect(project['webUrl'], startsWith('https://pub.dev/packages/'));
      expect(project['githubUrl'], startsWith('https://github.com/'));
      expect(
        (project['featuresKeys'] as List).length,
        (project['features'] as List).length,
        reason: 'lengths must match or tryTranslateList falls back to English',
      );
    }
  });
}
