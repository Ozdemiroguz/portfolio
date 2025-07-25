// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:portfolio_admin/features/apps/data/repositories/app_repository_impl.dart'
    as _i283;
import 'package:portfolio_admin/features/apps/domain/repositories/app_repository.dart'
    as _i626;
import 'package:portfolio_admin/features/auth/data/repositories/auth_repository_impl.dart'
    as _i906;
import 'package:portfolio_admin/features/auth/data/services/auth_service.dart'
    as _i159;
import 'package:portfolio_admin/features/auth/domain/repositories/auth_repository.dart'
    as _i516;
import 'package:portfolio_admin/features/portfolio/data/repositories/portfolio_repository_impl.dart'
    as _i767;
import 'package:portfolio_admin/features/portfolio/domain/repositories/portfolio_repository.dart'
    as _i44;
import 'package:portfolio_admin/features/shared/data/services/firestore_service.dart'
    as _i268;
import 'package:portfolio_admin/features/shared/data/services/storage_service.dart'
    as _i59;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i159.AuthService>(() => _i159.AuthService());
    gh.lazySingleton<_i268.FirestoreService>(() => _i268.FirestoreService());
    gh.lazySingleton<_i59.StorageService>(() => _i59.StorageService());
    gh.lazySingleton<_i516.AuthRepository>(
      () => _i906.AuthRepositoryImpl(
        gh<_i159.AuthService>(),
        gh<_i268.FirestoreService>(),
      ),
    );
    gh.lazySingleton<_i44.PortfolioRepository>(
      () => _i767.PortfolioRepositoryImpl(gh<_i268.FirestoreService>()),
    );
    gh.lazySingleton<_i626.AppRepository>(
      () => _i283.AppRepositoryImpl(gh<_i268.FirestoreService>()),
    );
    return this;
  }
}
