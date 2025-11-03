import '../entities/app_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Use case: Get apps inside a folder
/// Single responsibility: Fetch folder apps
class GetFolderApps {
  final PortfolioRepository repository;

  const GetFolderApps({required this.repository});

  Future<List<AppEntity>> call(String domain, List<String> appIds) async {
    return await repository.getAppsInFolder(domain, appIds);
  }
}
