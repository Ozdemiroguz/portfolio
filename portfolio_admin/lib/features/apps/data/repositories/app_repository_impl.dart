import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/app_repository.dart';
import '../../../shared/domain/models/app_model.dart';
import '../../../shared/data/services/firestore_service.dart';

@LazySingleton(as: AppRepository)
class AppRepositoryImpl implements AppRepository {
  final FirestoreService _firestoreService;

  AppRepositoryImpl(this._firestoreService);

  // Apps Home Implementation
  @override
  Future<List<AppModel>> getHomeApps(String portfolioId) async {
    final querySnapshot = await _firestoreService.getCollection(
      collection: 'portfolios/$portfolioId/apps_home',
    );

    final apps =
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return _parseAppFromFirestore(data, doc.id);
        }).toList();

    // Manuel sıralama
    apps.sort((a, b) => a.order.compareTo(b.order));
    return apps;
  }

  @override
  Future<void> createHomeApp(String portfolioId, AppModel app) async {
    final appData = _appToFirestore(app);

    await _firestoreService.setDocument(
      collection: 'portfolios/$portfolioId/apps_home',
      docId: app.id,
      data: appData,
    );
  }

  @override
  Future<void> updateHomeApp(String portfolioId, AppModel app) async {
    final appData = _appToFirestore(app);

    await _firestoreService.updateDocument(
      collection: 'portfolios/$portfolioId/apps_home',
      docId: app.id,
      data: appData,
    );
  }

  @override
  Future<void> deleteHomeApp(String portfolioId, String appId) async {
    await _firestoreService.deleteDocument(
      collection: 'portfolios/$portfolioId/apps_home',
      docId: appId,
    );
  }

  // Apps Folder Implementation
  @override
  Future<List<AppModel>> getFolderApps(
    String portfolioId,
    String folderId,
  ) async {
    final querySnapshot = await _firestoreService.getCollection(
      collection: 'portfolios/$portfolioId/apps_folder',
      queryBuilder: (query) => query.where('folderId', isEqualTo: folderId),
    );

    final apps =
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return _parseAppFromFirestore(data, doc.id);
        }).toList();

    // Manuel sıralama
    apps.sort((a, b) => a.order.compareTo(b.order));
    return apps;
  }

  @override
  Future<void> createFolderApp(
    String portfolioId,
    String folderId,
    AppModel app,
  ) async {
    final appData = _appToFirestore(app);
    appData['folderId'] = folderId; // Klasör ID'sini ekle

    await _firestoreService.setDocument(
      collection: 'portfolios/$portfolioId/apps_folder',
      docId: app.id,
      data: appData,
    );

    // Folder'ın appIds listesini güncelle
    final folderDoc = await _firestoreService.getDocument(
      collection: 'portfolios/$portfolioId/folders',
      docId: folderId,
    );

    if (folderDoc.exists) {
      final folderData = folderDoc.data() as Map<String, dynamic>;
      final currentAppIds = List<String>.from(folderData['appIds'] ?? []);

      if (!currentAppIds.contains(app.id)) {
        currentAppIds.add(app.id);
        await _firestoreService.updateDocument(
          collection: 'portfolios/$portfolioId/folders',
          docId: folderId,
          data: {'appIds': currentAppIds},
        );
      }
    }
  }

  @override
  Future<void> updateFolderApp(
    String portfolioId,
    String folderId,
    AppModel app,
  ) async {
    final appData = _appToFirestore(app);
    appData['folderId'] = folderId;

    await _firestoreService.updateDocument(
      collection: 'portfolios/$portfolioId/apps_folder',
      docId: app.id,
      data: appData,
    );
  }

  @override
  Future<void> deleteFolderApp(
    String portfolioId,
    String folderId,
    String appId,
  ) async {
    await _firestoreService.deleteDocument(
      collection: 'portfolios/$portfolioId/apps_folder',
      docId: appId,
    );

    // Folder'ın appIds listesinden çıkar
    final folderDoc = await _firestoreService.getDocument(
      collection: 'portfolios/$portfolioId/folders',
      docId: folderId,
    );

    if (folderDoc.exists) {
      final folderData = folderDoc.data() as Map<String, dynamic>;
      final currentAppIds = List<String>.from(folderData['appIds'] ?? []);

      if (currentAppIds.contains(appId)) {
        currentAppIds.remove(appId);
        await _firestoreService.updateDocument(
          collection: 'portfolios/$portfolioId/folders',
          docId: folderId,
          data: {'appIds': currentAppIds},
        );
      }
    }
  }

  // Apps Bottom Implementation
  @override
  Future<List<AppModel>> getBottomApps(String portfolioId) async {
    final querySnapshot = await _firestoreService.getCollection(
      collection: 'portfolios/$portfolioId/apps_bottom',
    );

    final apps =
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return _parseAppFromFirestore(data, doc.id);
        }).toList();

    // Manuel sıralama
    apps.sort((a, b) => a.order.compareTo(b.order));
    return apps;
  }

  @override
  Future<void> createBottomApp(String portfolioId, AppModel app) async {
    final appData = _appToFirestore(app);

    await _firestoreService.setDocument(
      collection: 'portfolios/$portfolioId/apps_bottom',
      docId: app.id,
      data: appData,
    );
  }

  @override
  Future<void> updateBottomApp(String portfolioId, AppModel app) async {
    final appData = _appToFirestore(app);

    await _firestoreService.updateDocument(
      collection: 'portfolios/$portfolioId/apps_bottom',
      docId: app.id,
      data: appData,
    );
  }

  @override
  Future<void> deleteBottomApp(String portfolioId, String appId) async {
    await _firestoreService.deleteDocument(
      collection: 'portfolios/$portfolioId/apps_bottom',
      docId: appId,
    );
  }

  // Folders Implementation
  @override
  Future<List<FolderModel>> getFolders(String portfolioId) async {
    final querySnapshot = await _firestoreService.getCollection(
      collection: 'portfolios/$portfolioId/folders',
    );

    final folders =
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return _parseFolderFromFirestore(data, doc.id);
        }).toList();

    // Manuel sıralama
    folders.sort((a, b) => a.order.compareTo(b.order));
    return folders;
  }

  @override
  Future<void> createFolder(String portfolioId, FolderModel folder) async {
    final folderData = _folderToFirestore(folder);

    await _firestoreService.setDocument(
      collection: 'portfolios/$portfolioId/folders',
      docId: folder.id,
      data: folderData,
    );
  }

  @override
  Future<void> updateFolder(String portfolioId, FolderModel folder) async {
    final folderData = _folderToFirestore(folder);

    await _firestoreService.updateDocument(
      collection: 'portfolios/$portfolioId/folders',
      docId: folder.id,
      data: folderData,
    );
  }

  @override
  Future<void> deleteFolder(String portfolioId, String folderId) async {
    // Önce klasör içindeki tüm uygulamaları sil
    final apps = await getFolderApps(portfolioId, folderId);
    for (final app in apps) {
      await deleteFolderApp(portfolioId, folderId, app.id);
    }

    // Sonra klasörü sil
    await _firestoreService.deleteDocument(
      collection: 'portfolios/$portfolioId/folders',
      docId: folderId,
    );
  }

  // Utilities Implementation
  @override
  Future<AppModel?> getAppById(
    String portfolioId,
    String appId,
    String location,
  ) async {
    final collection = 'portfolios/$portfolioId/apps_$location';

    final doc = await _firestoreService.getDocument(
      collection: collection,
      docId: appId,
    );

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return _parseAppFromFirestore(data, doc.id);
  }

  @override
  Future<void> reorderApps(
    String portfolioId,
    List<String> appIds,
    String location,
  ) async {
    final collection = 'portfolios/$portfolioId/apps_$location';

    for (int i = 0; i < appIds.length; i++) {
      await _firestoreService.updateDocument(
        collection: collection,
        docId: appIds[i],
        data: {'order': i},
      );
    }
  }

  @override
  Future<void> reorderFolders(
    String portfolioId,
    List<String> folderIds,
  ) async {
    for (int i = 0; i < folderIds.length; i++) {
      await _firestoreService.updateDocument(
        collection: 'portfolios/$portfolioId/folders',
        docId: folderIds[i],
        data: {'order': i},
      );
    }
  }

  // Private Helper Methods
  AppModel _parseAppFromFirestore(Map<String, dynamic> data, String id) {
    return AppModel(
      id: id,
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
      data: Map<String, dynamic>.from(data['data'] ?? {}),
    );
  }

  Map<String, dynamic> _appToFirestore(AppModel app) {
    return {
      'type': app.type,
      'title': app.title,
      'description': app.description,
      'icon': app.icon,
      'images': app.images,
      'createdAt': Timestamp.fromDate(app.createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'isActive': app.isActive,
      'order': app.order,
      'data': app.data,
    };
  }

  FolderModel _parseFolderFromFirestore(Map<String, dynamic> data, String id) {
    return FolderModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      color: data['color'] ?? '#2196F3',
      appIds: List<String>.from(data['appIds'] ?? []),
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> _folderToFirestore(FolderModel folder) {
    return {
      'title': folder.title,
      'description': folder.description,
      'icon': folder.icon,
      'color': folder.color,
      'appIds': folder.appIds,
      'order': folder.order,
      'isActive': folder.isActive,
      'createdAt': Timestamp.fromDate(folder.createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }
}
