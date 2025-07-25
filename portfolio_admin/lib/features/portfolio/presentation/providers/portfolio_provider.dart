import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/di/injection.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return getIt<PortfolioRepository>();
});

final userPortfoliosProvider = FutureProvider<List<PortfolioModel>>((
  ref,
) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final portfolioRepository = ref.watch(portfolioRepositoryProvider);

  final user = authRepository.currentUser;
  if (user == null) return [];

  return await portfolioRepository.getUserPortfolios(user.uid);
});

final portfolioByDomainProvider = FutureProviderFamily<PortfolioModel?, String>(
  (ref, domain) async {
    final portfolioRepository = ref.watch(portfolioRepositoryProvider);
    return await portfolioRepository.getPortfolioByDomain(domain);
  },
);

class PortfolioNotifier extends StateNotifier<AsyncValue<void>> {
  final PortfolioRepository _portfolioRepository;
  final Ref _ref;

  PortfolioNotifier(this._portfolioRepository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> createPortfolio({
    required String domain,
    required String title,
    required String description,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final user = authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Domain benzersizliği kontrolü
      final isDomainAvailable = await _portfolioRepository.isDomainAvailable(
        domain,
      );
      if (!isDomainAvailable) {
        throw Exception('Bu domain adı zaten kullanılıyor');
      }

      // Yeni portfolio oluştur
      final now = DateTime.now();
      final portfolio = PortfolioModel(
        id: '', // Repository'de set edilecek
        domain: domain,
        title: title,
        description: description,
        ownerId: user.uid,
        createdAt: now,
        updatedAt: now,
        isPublic: false,
        portfolioType: 'mobile',
        theme: const ThemeConfig(
          mode: 'light', // Başlangıç modu: açık tema
          primaryColor: '#1E88E5', // Material Blue
          backgroundColor: '#F5F5F5', // Açık gri arka plan
          textColor: '#212121', // Koyu metin
          accentColor: '#FF4081', // Material Pink accent
        ),
        socialLinks: const [],
        skills: const [],
        tags: const [],
        languages: const ['tr', 'en'],
        defaultLocale: 'tr',
      );

      await _portfolioRepository.createPortfolio(portfolio);

      // Kullanıcının portfolio listesine ekle
      await _portfolioRepository.addPortfolioToUser(
        userId: user.uid,
        domain: domain,
      );

      // Provider'ları yenile
      _ref.invalidate(userPortfoliosProvider);
      _ref.invalidate(currentUserDataProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    state = const AsyncValue.loading();

    try {
      await _portfolioRepository.updatePortfolio(portfolio);

      // Provider'ları yenile
      _ref.invalidate(userPortfoliosProvider);
      _ref.invalidate(portfolioByDomainProvider(portfolio.domain));

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePortfolio(PortfolioModel portfolio) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final user = authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Portfolio'yu sil
      await _portfolioRepository.deletePortfolio(portfolio.id);

      // Kullanıcının portfolio listesinden çıkar
      await _portfolioRepository.removePortfolioFromUser(
        userId: user.uid,
        domain: portfolio.domain,
      );

      // Provider'ları yenile
      _ref.invalidate(userPortfoliosProvider);
      _ref.invalidate(currentUserDataProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> isDomainAvailable(String domain) async {
    return await _portfolioRepository.isDomainAvailable(domain);
  }
}

final portfolioNotifierProvider =
    StateNotifierProvider<PortfolioNotifier, AsyncValue<void>>((ref) {
      final portfolioRepository = ref.watch(portfolioRepositoryProvider);
      return PortfolioNotifier(portfolioRepository, ref);
    });
