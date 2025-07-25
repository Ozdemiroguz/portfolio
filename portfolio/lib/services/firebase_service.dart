import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio.dart';
import '../models/app.dart';
import '../models/folder.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Domain'den portfolio document ID'sini bul
  Future<String?> _getPortfolioIdByDomain(String domain) async {
    try {
      final query =
          await _firestore
              .collection('portfolios')
              .where('domain', isEqualTo: domain)
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.id;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Portfolio ID getirme hatası: $e');
      return null;
    }
  }

  // Portfolio işlemleri
  Future<Portfolio?> getPortfolio(String domain) async {
    debugPrint('🔍 Firebase: Portfolio getiriliyor - domain: $domain');
    try {
      debugPrint('📊 Firestore query: portfolios where domain == $domain');
      final query =
          await _firestore
              .collection('portfolios')
              .where('domain', isEqualTo: domain)
              .limit(1)
              .get();

      debugPrint('📄 Query sonucu: ${query.docs.length} document');
      if (query.docs.isNotEmpty) {
        debugPrint('✅ Portfolio verisi bulundu');
        final doc = query.docs.first;
        final data = doc.data();
        debugPrint('📋 Portfolio document ID: ${doc.id}');
        debugPrint('📋 Portfolio data keys: ${data.keys.toList()}');
        return Portfolio.fromJson(data);
      } else {
        debugPrint('❌ Domain için portfolio bulunamadı');
      }
      return null;
    } catch (e) {
      debugPrint('❌ Portfolio getirme hatası: $e');
      debugPrint('❌ Hata tipi: ${e.runtimeType}');
      return null;
    }
  }

  // Portfolio altındaki klasörleri getir
  Future<List<Folder>> getFolders(String domain) async {
    debugPrint('📁 Firebase: Folders getiriliyor - domain: $domain');
    try {
      final portfolioId = await _getPortfolioIdByDomain(domain);
      if (portfolioId == null) {
        debugPrint('❌ Portfolio ID bulunamadı');
        return [];
      }

      debugPrint('📊 Query: portfolios/$portfolioId/folders (isActive=true)');
      final query =
          await _firestore
              .collection('portfolios')
              .doc(portfolioId)
              .collection('folders')
              .where('isActive', isEqualTo: true)
              .get();

      debugPrint('📁 Tüm aktif folders bulunan: ${query.docs.length}');

      // Client-side'da sıralama
      final folders =
          query.docs.map((doc) => Folder.fromJson(doc.data())).toList();

      // Order'a göre sırala
      folders.sort((a, b) => a.order.compareTo(b.order));

      debugPrint('📁 Folders sıralandı: ${folders.length}');
      for (var folder in folders) {
        debugPrint(
          '📄 Folder: ${folder.id} - ${folder.title} (order: ${folder.order}) - appIds: ${folder.appIds}',
        );
        debugPrint(
          '📄 Folder ${folder.title} içindeki app sayısı: ${folder.appIds.length}',
        );
      }

      return folders;
    } catch (e) {
      debugPrint('❌ Klasörler getirme hatası: $e');
      debugPrint('❌ Hata detayı: ${e.toString()}');
      return [];
    }
  }

  // Ana ekran uygulamalarını getir (bottom apps ve folder içindeki apps hariç)
  Future<List<App>> getHomeApps(String domain) async {
    debugPrint('🏠 Firebase: Home apps getiriliyor - domain: $domain');
    try {
      final portfolioId = await _getPortfolioIdByDomain(domain);
      if (portfolioId == null) {
        debugPrint('❌ Portfolio ID bulunamadı');
        return [];
      }

      debugPrint('📊 Query: portfolios/$portfolioId/apps_home (isActive=true)');
      final query =
          await _firestore
              .collection('portfolios')
              .doc(portfolioId)
              .collection('apps_home')
              .where('isActive', isEqualTo: true)
              .get();

      debugPrint('📱 apps_home bulunan: ${query.docs.length}');

      final apps =
          query.docs.map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id; // Document ID'yi data'ya ekle
            return App.fromJson(data);
          }).toList();

      // Order'a göre sırala
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
      debugPrint('❌ Hata detayı: ${e.toString()}');
      return [];
    }
  }

  // Alt dock uygulamalarını getir
  Future<List<App>> getBottomApps(String domain) async {
    debugPrint('⬇️ Firebase: Bottom apps getiriliyor - domain: $domain');
    try {
      final portfolioId = await _getPortfolioIdByDomain(domain);
      if (portfolioId == null) {
        debugPrint('❌ Portfolio ID bulunamadı');
        return [];
      }

      debugPrint(
        '📊 Query: portfolios/$portfolioId/apps_bottom (isActive=true)',
      );
      final query =
          await _firestore
              .collection('portfolios')
              .doc(portfolioId)
              .collection('apps_bottom')
              .where('isActive', isEqualTo: true)
              .get();

      debugPrint('📱 apps_bottom bulunan: ${query.docs.length}');

      final apps =
          query.docs.map((doc) {
            final data = doc.data();
            data['id'] = data['id'] ?? doc.id; // Document ID'yi data'ya ekle
            return App.fromJson(data);
          }).toList();

      // Order'a göre sırala
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
      debugPrint('❌ Hata detayı: ${e.toString()}');
      return [];
    }
  }

  // Belirli bir uygulamayı getir
  Future<App?> getApp(String portfolioId, String appId) async {
    try {
      final doc =
          await _firestore
              .collection('portfolios')
              .doc(portfolioId)
              .collection('apps')
              .doc(appId)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = data['id'] ?? doc.id; // Document ID'yi data'ya ekle
        return App.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Uygulama getirme hatası: $e');
      return null;
    }
  }

  // Klasördeki uygulamaları getir
  Future<List<App>> getAppsInFolder(String domain, List<String> appIds) async {
    debugPrint('🔍🔍🔍 getAppsInFolder BAŞLADI - domain: $domain');
    debugPrint('🔍🔍🔍 Aranan appIds: $appIds (toplam: ${appIds.length})');
    if (appIds.isEmpty) {
      debugPrint('❌❌❌ appIds boş, boş liste döndürülüyor');
      return [];
    }

    try {
      final portfolioId = await _getPortfolioIdByDomain(domain);
      if (portfolioId == null) {
        debugPrint('❌ Portfolio ID bulunamadı');
        return [];
      }

      // apps_folder collection'ından TÜM uygulamaları getir
      final query =
          await _firestore
              .collection('portfolios')
              .doc(portfolioId)
              .collection('apps_folder')
              .where('isActive', isEqualTo: true)
              .get();

      debugPrint(
        '📱 apps_folder collection\'da bulunan toplam app: ${query.docs.length}',
      );

      // Tüm apps_folder uygulamalarını listele
      for (var doc in query.docs) {
        final data = doc.data();
        debugPrint(
          '📄 apps_folder App: ID=${data['id']}, Title=${data['title']}, DocID=${doc.id}',
        );
      }

      debugPrint('🎯 Folder\'dan aranan appIds: $appIds');

      // İki ayrı liste oluşturalım ve eşleştirelim
      final allApps = <App>[];
      final docIdToApp = <String, App>{};

      // Tüm apps_folder uygulamalarını App nesnesine çevir
      for (var doc in query.docs) {
        final data = doc.data();
        data['id'] = data['id'] ?? doc.id; // Document ID'yi data'ya ekle
        final app = App.fromJson(data);
        allApps.add(app);
        docIdToApp[doc.id] = app; // Document ID ile app eşleştirmesi
      }

      // Şimdi appIds ile eşleştirme yapalım
      final matchedApps = <App>[];

      for (var appId in appIds) {
        // Önce app.id ile kontrol et
        var foundApp = allApps.where((app) => app.id == appId).firstOrNull;

        // Bulunamazsa document ID ile kontrol et
        foundApp ??= docIdToApp[appId];

        if (foundApp != null) {
          matchedApps.add(foundApp);
          debugPrint('✅ Eşleşti: appId=$appId -> ${foundApp.title}');
        } else {
          debugPrint('❌ Eşleşmedi: appId=$appId');
        }
      }

      final apps = matchedApps;

      debugPrint('✅✅✅ Eşleşen folder apps: ${apps.length}');
      for (var app in apps) {
        debugPrint('📱📱📱 Eşleşen app: ${app.id} - ${app.title}');
      }

      // Client-side'da sıralama
      apps.sort((a, b) => a.order.compareTo(b.order));

      debugPrint(
        '🎯🎯🎯 getAppsInFolder SONUÇ: ${apps.length} app döndürülüyor',
      );
      return apps;
    } catch (e) {
      debugPrint('❌ Klasör uygulamaları getirme hatası: $e');
      return [];
    }
  }

  // İletişim mesajı gönder
  Future<bool> sendContactMessage(
    String portfolioId,
    String email,
    String title,
    String message,
  ) async {
    try {
      await _firestore
          .collection('portfolios')
          .doc(portfolioId)
          .collection('contact_messages')
          .add({
            'email': email,
            'title': title,
            'message': message,
            'sentAt': DateTime.now().toIso8601String(),
          });
      return true;
    } catch (e) {
      debugPrint('Mesaj gönderme hatası: $e');
      return false;
    }
  }
}
