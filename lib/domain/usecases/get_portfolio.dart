import '../entities/portfolio_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Use case: Get portfolio by domain
/// Single responsibility: Fetch portfolio data
class GetPortfolio {
  final PortfolioRepository repository;

  const GetPortfolio({required this.repository});

  Future<PortfolioEntity?> call(String domain) async {
    return await repository.getPortfolio(domain);
  }
}
