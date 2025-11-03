import '../entities/app_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Use case: Get home screen apps
/// Single responsibility: Fetch home apps
class GetHomeApps {
  final PortfolioRepository repository;

  const GetHomeApps({required this.repository});

  Future<List<AppEntity>> call(String domain) async {
    return await repository.getHomeApps(domain);
  }
}
