import '../../../shared/domain/models/portfolio_model.dart';

abstract class PortfolioRepository {
  Future<List<PortfolioModel>> getUserPortfolios(String userId);

  Future<PortfolioModel?> getPortfolioById(String portfolioId);

  Future<PortfolioModel?> getPortfolioByDomain(String domain);

  Future<void> createPortfolio(PortfolioModel portfolio);

  Future<void> updatePortfolio(PortfolioModel portfolio);

  Future<void> deletePortfolio(String portfolioId);

  Future<bool> isDomainAvailable(String domain);

  Future<void> addPortfolioToUser({
    required String userId,
    required String domain,
  });

  Future<void> removePortfolioFromUser({
    required String userId,
    required String domain,
  });
}
