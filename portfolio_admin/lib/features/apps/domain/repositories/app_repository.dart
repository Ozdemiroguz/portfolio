import '../../../shared/domain/models/app_model.dart';

abstract class AppRepository {
  // Apps Home (Ana ekran uygulamaları)
  Future<List<AppModel>> getHomeApps(String portfolioId);
  Future<void> createHomeApp(String portfolioId, AppModel app);
  Future<void> updateHomeApp(String portfolioId, AppModel app);
  Future<void> deleteHomeApp(String portfolioId, String appId);

  // Apps Folder (Klasör içi uygulamaları)
  Future<List<AppModel>> getFolderApps(String portfolioId, String folderId);
  Future<void> createFolderApp(
    String portfolioId,
    String folderId,
    AppModel app,
  );
  Future<void> updateFolderApp(
    String portfolioId,
    String folderId,
    AppModel app,
  );
  Future<void> deleteFolderApp(
    String portfolioId,
    String folderId,
    String appId,
  );

  // Apps Bottom (Alt panel uygulamaları)
  Future<List<AppModel>> getBottomApps(String portfolioId);
  Future<void> createBottomApp(String portfolioId, AppModel app);
  Future<void> updateBottomApp(String portfolioId, AppModel app);
  Future<void> deleteBottomApp(String portfolioId, String appId);

  // Folders
  Future<List<FolderModel>> getFolders(String portfolioId);
  Future<void> createFolder(String portfolioId, FolderModel folder);
  Future<void> updateFolder(String portfolioId, FolderModel folder);
  Future<void> deleteFolder(String portfolioId, String folderId);

  // Utilities
  Future<AppModel?> getAppById(
    String portfolioId,
    String appId,
    String location,
  );
  Future<void> reorderApps(
    String portfolioId,
    List<String> appIds,
    String location,
  );
  Future<void> reorderFolders(String portfolioId, List<String> folderIds);
}
