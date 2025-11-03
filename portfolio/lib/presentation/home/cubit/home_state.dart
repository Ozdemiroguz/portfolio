import 'package:equatable/equatable.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../domain/entities/folder_entity.dart';

/// Home state
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded state
class HomeLoaded extends HomeState {
  final List<AppEntity> homeApps;
  final List<AppEntity> bottomApps;
  final List<FolderEntity> folders;
  final AppEntity? openApp;
  final FolderEntity? openFolder;
  final List<AppEntity> folderApps;
  final bool showLanguageOverlay;

  const HomeLoaded({
    required this.homeApps,
    required this.bottomApps,
    required this.folders,
    this.openApp,
    this.openFolder,
    this.folderApps = const [],
    this.showLanguageOverlay = false,
  });

  HomeLoaded copyWith({
    List<AppEntity>? homeApps,
    List<AppEntity>? bottomApps,
    List<FolderEntity>? folders,
    AppEntity? openApp,
    FolderEntity? openFolder,
    List<AppEntity>? folderApps,
    bool? showLanguageOverlay,
    bool clearOpenApp = false,
    bool clearOpenFolder = false,
  }) {
    return HomeLoaded(
      homeApps: homeApps ?? this.homeApps,
      bottomApps: bottomApps ?? this.bottomApps,
      folders: folders ?? this.folders,
      openApp: clearOpenApp ? null : (openApp ?? this.openApp),
      openFolder: clearOpenFolder ? null : (openFolder ?? this.openFolder),
      folderApps: folderApps ?? this.folderApps,
      showLanguageOverlay: showLanguageOverlay ?? this.showLanguageOverlay,
    );
  }

  @override
  List<Object?> get props => [
        homeApps,
        bottomApps,
        folders,
        openApp,
        openFolder,
        folderApps,
        showLanguageOverlay,
      ];
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
