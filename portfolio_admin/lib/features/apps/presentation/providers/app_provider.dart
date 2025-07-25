import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/app_repository.dart';
import '../../../shared/domain/models/app_model.dart';
import '../../../../core/di/injection.dart';

// Repository Provider
final appRepositoryProvider = Provider<AppRepository>((ref) {
  return getIt<AppRepository>();
});

// Home Apps Provider
final homeAppsProvider = FutureProvider.family<List<AppModel>, String>((
  ref,
  portfolioId,
) async {
  final repository = ref.read(appRepositoryProvider);
  return repository.getHomeApps(portfolioId);
});

// Folder Apps Provider
final folderAppsProvider =
    FutureProvider.family<List<AppModel>, (String, String)>((
      ref,
      params,
    ) async {
      final repository = ref.read(appRepositoryProvider);
      return repository.getFolderApps(params.$1, params.$2);
    });

// Bottom Apps Provider
final bottomAppsProvider = FutureProvider.family<List<AppModel>, String>((
  ref,
  portfolioId,
) async {
  final repository = ref.read(appRepositoryProvider);
  return repository.getBottomApps(portfolioId);
});

// Folders Provider
final foldersProvider = FutureProvider.family<List<FolderModel>, String>((
  ref,
  portfolioId,
) async {
  final repository = ref.read(appRepositoryProvider);
  return repository.getFolders(portfolioId);
});

// App Detail Provider
final appDetailProvider =
    FutureProvider.family<AppModel?, (String, String, String)>((
      ref,
      params,
    ) async {
      final repository = ref.read(appRepositoryProvider);
      return repository.getAppById(params.$1, params.$2, params.$3);
    });

// App Notifier for CRUD operations
class AppNotifier extends StateNotifier<AsyncValue<void>> {
  final AppRepository _repository;
  final Ref _ref;

  AppNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  // Home Apps CRUD
  Future<void> createHomeApp(String portfolioId, AppModel app) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createHomeApp(portfolioId, app);
      _ref.invalidate(homeAppsProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateHomeApp(String portfolioId, AppModel app) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateHomeApp(portfolioId, app);
      _ref.invalidate(homeAppsProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteHomeApp(String portfolioId, String appId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteHomeApp(portfolioId, appId);
      _ref.invalidate(homeAppsProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Folder Apps CRUD
  Future<void> createFolderApp(
    String portfolioId,
    String folderId,
    AppModel app,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createFolderApp(portfolioId, folderId, app);
      _ref.invalidate(folderAppsProvider((portfolioId, folderId)));
      _ref.invalidate(foldersProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateFolderApp(
    String portfolioId,
    String folderId,
    AppModel app,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateFolderApp(portfolioId, folderId, app);
      _ref.invalidate(folderAppsProvider((portfolioId, folderId)));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteFolderApp(
    String portfolioId,
    String folderId,
    String appId,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteFolderApp(portfolioId, folderId, appId);
      _ref.invalidate(folderAppsProvider((portfolioId, folderId)));
      _ref.invalidate(foldersProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Bottom Apps CRUD
  Future<void> createBottomApp(String portfolioId, AppModel app) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createBottomApp(portfolioId, app);
      _ref.invalidate(bottomAppsProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBottomApp(String portfolioId, AppModel app) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateBottomApp(portfolioId, app);
      _ref.invalidate(bottomAppsProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteBottomApp(String portfolioId, String appId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteBottomApp(portfolioId, appId);
      _ref.invalidate(bottomAppsProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Folders CRUD
  Future<void> createFolder(String portfolioId, FolderModel folder) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createFolder(portfolioId, folder);
      _ref.invalidate(foldersProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateFolder(String portfolioId, FolderModel folder) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateFolder(portfolioId, folder);
      _ref.invalidate(foldersProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteFolder(String portfolioId, String folderId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteFolder(portfolioId, folderId);
      _ref.invalidate(foldersProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Utilities
  Future<void> reorderApps(
    String portfolioId,
    List<String> appIds,
    String location,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.reorderApps(portfolioId, appIds, location);

      // Refresh appropriate provider based on location
      switch (location) {
        case 'home':
          _ref.invalidate(homeAppsProvider(portfolioId));
          break;
        case 'bottom':
          _ref.invalidate(bottomAppsProvider(portfolioId));
          break;
      }

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> reorderFolders(
    String portfolioId,
    List<String> folderIds,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.reorderFolders(portfolioId, folderIds);
      _ref.invalidate(foldersProvider(portfolioId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final appNotifierProvider =
    StateNotifierProvider<AppNotifier, AsyncValue<void>>((ref) {
      final repository = ref.read(appRepositoryProvider);
      return AppNotifier(repository, ref);
    });
