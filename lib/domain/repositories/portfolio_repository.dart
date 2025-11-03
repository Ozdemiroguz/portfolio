import '../entities/portfolio_entity.dart';
import '../entities/app_entity.dart';
import '../entities/folder_entity.dart';

/// Portfolio repository interface (domain layer)
/// Defines the contract for portfolio data operations
abstract class PortfolioRepository {
  /// Get portfolio by domain
  Future<PortfolioEntity?> getPortfolio(String domain);

  /// Get folders for a domain
  Future<List<FolderEntity>> getFolders(String domain);

  /// Get home screen apps
  Future<List<AppEntity>> getHomeApps(String domain);

  /// Get bottom dock apps
  Future<List<AppEntity>> getBottomApps(String domain);

  /// Get apps inside a folder
  Future<List<AppEntity>> getAppsInFolder(String domain, List<String> appIds);

  /// Send contact message
  Future<bool> sendContactMessage(
    String portfolioId,
    String email,
    String title,
    String message,
  );
}
