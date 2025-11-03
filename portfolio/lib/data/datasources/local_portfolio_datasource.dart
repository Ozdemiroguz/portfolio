import 'package:flutter/foundation.dart';
import '../models/portfolio_model.dart';
import '../models/app_model.dart';
import '../models/folder_model.dart';
import 'portfolio_datasource.dart';
import '../portfolio_data.dart';

/// Local portfolio data source implementation
/// Fetches data from local const data
class LocalPortfolioDataSource implements PortfolioDataSource {
  /// Get portfolio data by domain
  Map<String, dynamic>? _getPortfolioDataByDomain(String domain) {
    if (portfolioData.containsKey(domain)) {
      return portfolioData[domain] as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Future<PortfolioModel?> getPortfolio(String domain) async {
    debugPrint('🔍 LocalData: Portfolio getiriliyor - domain: $domain');

    // Simulate network delay for realistic UX
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final data = _getPortfolioDataByDomain(domain);

      if (data == null) {
        debugPrint('❌ Domain için portfolio bulunamadı');
        return null;
      }

      final portfolioJson = data['portfolio'] as Map<String, dynamic>;
      debugPrint('✅ Portfolio verisi bulundu');
      return PortfolioModel.fromJson(portfolioJson);
    } catch (e) {
      debugPrint('❌ Portfolio getirme hatası: $e');
      return null;
    }
  }

  @override
  Future<List<FolderModel>> getFolders(String domain) async {
    debugPrint('📁 LocalData: Folders getiriliyor - domain: $domain');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final data = _getPortfolioDataByDomain(domain);

      if (data == null) {
        debugPrint('❌ Domain için portfolio bulunamadı');
        return [];
      }

      final foldersJson = data['folders'] as List<dynamic>?;

      if (foldersJson == null) {
        debugPrint('📁 Folder bulunamadı');
        return [];
      }

      final folders = foldersJson
          .map((json) => FolderModel.fromJson(json as Map<String, dynamic>))
          .where((folder) => folder.isActive)
          .toList();

      // Sort by order
      folders.sort((a, b) => a.order.compareTo(b.order));

      debugPrint('📁 Folders yüklendi: ${folders.length}');
      for (var folder in folders) {
        debugPrint(
          '📄 Folder: ${folder.id} - ${folder.title} (order: ${folder.order}) - appIds: ${folder.appIds}',
        );
      }

      return folders;
    } catch (e) {
      debugPrint('❌ Klasörler getirme hatası: $e');
      return [];
    }
  }

  @override
  Future<List<AppModel>> getHomeApps(String domain) async {
    debugPrint('🏠 LocalData: Home apps getiriliyor - domain: $domain');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final data = _getPortfolioDataByDomain(domain);

      if (data == null) {
        debugPrint('❌ Domain için portfolio bulunamadı');
        return [];
      }

      final appsJson = data['apps_home'] as List<dynamic>?;

      if (appsJson == null) {
        debugPrint('📱 apps_home bulunamadı');
        return [];
      }

      final apps = appsJson
          .map((json) => AppModel.fromJson(json as Map<String, dynamic>))
          .where((app) => app.isActive)
          .toList();

      // Sort by order
      apps.sort((a, b) => a.order.compareTo(b.order));

      debugPrint('📱 Home apps yüklendi: ${apps.length}');
      for (var app in apps) {
        debugPrint(
          '📄 Home App: ${app.id} - ${app.title} (order: ${app.order}, type: ${app.type})',
        );
      }

      return apps;
    } catch (e) {
      debugPrint('❌ Ana ekran uygulamaları getirme hatası: $e');
      return [];
    }
  }

  @override
  Future<List<AppModel>> getBottomApps(String domain) async {
    debugPrint('⬇️ LocalData: Bottom apps getiriliyor - domain: $domain');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final data = _getPortfolioDataByDomain(domain);

      if (data == null) {
        debugPrint('❌ Domain için portfolio bulunamadı');
        return [];
      }

      final appsJson = data['apps_bottom'] as List<dynamic>?;

      if (appsJson == null) {
        debugPrint('📱 apps_bottom bulunamadı');
        return [];
      }

      final apps = appsJson
          .map((json) => AppModel.fromJson(Map<String, dynamic>.from(json as Map)))
          .where((app) => app.isActive)
          .toList();

      // Sort by order
      apps.sort((a, b) => a.order.compareTo(b.order));

      debugPrint('📱 Bottom apps yüklendi: ${apps.length}');
      for (var app in apps) {
        debugPrint(
          '📄 Bottom App: ${app.id} - ${app.title} (order: ${app.order})',
        );
      }

      return apps;
    } catch (e) {
      debugPrint('❌ Alt dock uygulamaları getirme hatası: $e');
      return [];
    }
  }

  @override
  Future<List<AppModel>> getAppsInFolder(
    String domain,
    List<String> appIds,
  ) async {
    debugPrint('🔍 LocalData: getAppsInFolder - domain: $domain');
    debugPrint('🔍 Aranan appIds: $appIds (toplam: ${appIds.length})');

    if (appIds.isEmpty) {
      debugPrint('❌ appIds boş, boş liste döndürülüyor');
      return [];
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final data = _getPortfolioDataByDomain(domain);

      if (data == null) {
        debugPrint('❌ Domain için portfolio bulunamadı');
        return [];
      }

      final appsJson = data['apps_folder'] as List<dynamic>?;

      if (appsJson == null) {
        debugPrint('📱 apps_folder bulunamadı');
        return [];
      }

      // Load all folder apps
      final allApps = appsJson
          .map((json) => AppModel.fromJson(json as Map<String, dynamic>))
          .where((app) => app.isActive)
          .toList();

      debugPrint('📱 Toplam apps_folder: ${allApps.length}');

      // Filter by appIds
      final matchedApps =
          allApps.where((app) => appIds.contains(app.id)).toList();

      debugPrint('✅ Eşleşen folder apps: ${matchedApps.length}');
      for (var app in matchedApps) {
        debugPrint('📱 Eşleşen app: ${app.id} - ${app.title}');
      }

      // Sort by order
      matchedApps.sort((a, b) => a.order.compareTo(b.order));

      return matchedApps;
    } catch (e) {
      debugPrint('❌ Klasör uygulamaları getirme hatası: $e');
      return [];
    }
  }

  @override
  Future<bool> sendContactMessage(
    String portfolioId,
    String email,
    String title,
    String message,
  ) async {
    debugPrint('📧 LocalData: İletişim mesajı simüle ediliyor');
    debugPrint('Email: $email');
    debugPrint('Başlık: $title');
    debugPrint('Mesaj: $message');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In local environment, just log to console
    debugPrint('✅ Mesaj başarıyla gönderildi (simüle edildi)');
    return true;
  }
}
