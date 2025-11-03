import '../models/portfolio_model.dart';
import '../models/app_model.dart';
import '../models/folder_model.dart';

/// Portfolio data source interface
/// Defines contract for fetching portfolio data
abstract class PortfolioDataSource {
  /// Get portfolio by domain
  Future<PortfolioModel?> getPortfolio(String domain);

  /// Get folders for a domain
  Future<List<FolderModel>> getFolders(String domain);

  /// Get home screen apps
  Future<List<AppModel>> getHomeApps(String domain);

  /// Get bottom dock apps
  Future<List<AppModel>> getBottomApps(String domain);

  /// Get apps inside a folder
  Future<List<AppModel>> getAppsInFolder(String domain, List<String> appIds);

  /// Send contact message
  Future<bool> sendContactMessage(
    String portfolioId,
    String email,
    String title,
    String message,
  );
}
