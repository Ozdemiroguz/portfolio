import 'package:get_it/get_it.dart';
import '../../data/datasources/local_portfolio_datasource.dart';
import '../../data/datasources/portfolio_datasource.dart';
import '../../data/repositories/portfolio_repository_impl.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../domain/usecases/get_portfolio.dart';
import '../../domain/usecases/get_folders.dart';
import '../../domain/usecases/get_home_apps.dart';
import '../../domain/usecases/get_bottom_apps.dart';
import '../../domain/usecases/get_folder_apps.dart';
import '../../domain/usecases/send_contact_message.dart';
import '../../presentation/home/cubit/home_cubit.dart';
import '../../presentation/portfolio/cubit/portfolio_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies() async {
  // Data sources
  sl.registerLazySingleton<PortfolioDataSource>(
    () => LocalPortfolioDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPortfolio(repository: sl()));
  sl.registerLazySingleton(() => GetFolders(repository: sl()));
  sl.registerLazySingleton(() => GetHomeApps(repository: sl()));
  sl.registerLazySingleton(() => GetBottomApps(repository: sl()));
  sl.registerLazySingleton(() => GetFolderApps(repository: sl()));
  sl.registerLazySingleton(() => SendContactMessage(repository: sl()));

  // Cubits (factories for new instances on each call)
  sl.registerFactory(
    () => HomeCubit(
      getHomeApps: sl(),
      getBottomApps: sl(),
      getFolders: sl(),
      getFolderApps: sl(),
    ),
  );

  sl.registerFactory(
    () => PortfolioCubit(
      getPortfolio: sl(),
    ),
  );
}
