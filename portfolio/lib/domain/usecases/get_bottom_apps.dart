import '../entities/app_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Use case: Get bottom dock apps
/// Single responsibility: Fetch bottom dock apps
class GetBottomApps {
  final PortfolioRepository repository;

  const GetBottomApps({required this.repository});

  Future<List<AppEntity>> call(String domain) async {
    return await repository.getBottomApps(domain);
  }
}
