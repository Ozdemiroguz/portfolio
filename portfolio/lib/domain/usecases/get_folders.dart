import '../entities/folder_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Use case: Get folders for a domain
/// Single responsibility: Fetch folder list
class GetFolders {
  final PortfolioRepository repository;

  const GetFolders({required this.repository});

  Future<List<FolderEntity>> call(String domain) async {
    return await repository.getFolders(domain);
  }
}
