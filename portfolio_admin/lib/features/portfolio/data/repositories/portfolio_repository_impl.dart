import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../../../shared/data/services/firestore_service.dart';

@LazySingleton(as: PortfolioRepository)
class PortfolioRepositoryImpl implements PortfolioRepository {
  final FirestoreService _firestoreService;

  PortfolioRepositoryImpl(this._firestoreService);

  @override
  Future<List<PortfolioModel>> getUserPortfolios(String userId) async {
    final userDoc = await _firestoreService.getDocument(
      collection: 'users',
      docId: userId,
    );

    if (!userDoc.exists) return [];

    final userData = userDoc.data() as Map<String, dynamic>;
    final portfolioIds = List<String>.from(userData['portfolios'] ?? []);

    if (portfolioIds.isEmpty) return [];

    final portfolios = <PortfolioModel>[];

    for (final portfolioId in portfolioIds) {
      final portfolio = await getPortfolioByDomain(portfolioId);
      if (portfolio != null) {
        portfolios.add(portfolio);
      }
    }

    return portfolios;
  }

  @override
  Future<PortfolioModel?> getPortfolioById(String portfolioId) async {
    final doc = await _firestoreService.getDocument(
      collection: 'portfolios',
      docId: portfolioId,
    );

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return _parsePortfolioFromFirestore(data, doc.id);
  }

  @override
  Future<PortfolioModel?> getPortfolioByDomain(String domain) async {
    final querySnapshot = await _firestoreService.getCollection(
      collection: 'portfolios',
      queryBuilder:
          (query) => query.where('domain', isEqualTo: domain).limit(1),
    );

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;
    final data = doc.data() as Map<String, dynamic>;
    return _parsePortfolioFromFirestore(data, doc.id);
  }

  PortfolioModel _parsePortfolioFromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    // Theme parsing
    final themeData = data['theme'] as Map<String, dynamic>? ?? {};
    final theme = ThemeConfig(
      mode: themeData['mode'] ?? 'light',
      primaryColor: themeData['primaryColor'] ?? '#1E88E5',
      backgroundColor: themeData['backgroundColor'] ?? '#F9F9F9',
      textColor: themeData['textColor'] ?? '#212121',
      accentColor: themeData['accentColor'] ?? '#FF4081',
    );

    // Social links parsing
    final socialLinksData = (data['socialLinks'] as List?) ?? [];
    final socialLinks =
        socialLinksData.map((link) {
          final linkMap = link as Map<String, dynamic>;
          return SocialLink(type: linkMap['type'] ?? '', url: linkMap['url']);
        }).toList();

    // Date parsing - Firestore'dan gelen Timestamp'leri DateTime'a çevir
    DateTime parseDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      } else {
        return DateTime.now();
      }
    }

    return PortfolioModel(
      id: id,
      domain: data['domain'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      createdAt: parseDateTime(data['createdAt']),
      updatedAt: parseDateTime(data['updatedAt']),
      isPublic: data['isPublic'] ?? false,
      customDomain: data['customDomain'],
      coverImage: data['coverImage'],
      profilePhoto: data['profilePhoto'],
      portfolioType: data['portfolioType'] ?? 'mobile',
      theme: theme,
      socialLinks: socialLinks,
      skills: List<String>.from(data['skills'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      languages: List<String>.from(data['languages'] ?? ['tr', 'en']),
      defaultLocale: data['defaultLocale'] ?? 'tr',
    );
  }

  Map<String, dynamic> _portfolioToFirestore(PortfolioModel portfolio) {
    return {
      'domain': portfolio.domain,
      'title': portfolio.title,
      'description': portfolio.description,
      'ownerId': portfolio.ownerId,
      'createdAt': Timestamp.fromDate(portfolio.createdAt),
      'updatedAt': Timestamp.fromDate(portfolio.updatedAt),
      'isPublic': portfolio.isPublic,
      'customDomain': portfolio.customDomain,
      'coverImage': portfolio.coverImage,
      'profilePhoto': portfolio.profilePhoto,
      'portfolioType': portfolio.portfolioType,
      'theme': {
        'mode': portfolio.theme.mode,
        'primaryColor': portfolio.theme.primaryColor,
        'backgroundColor': portfolio.theme.backgroundColor,
        'textColor': portfolio.theme.textColor,
        'accentColor': portfolio.theme.accentColor,
      },
      'socialLinks':
          portfolio.socialLinks
              .map((link) => {'type': link.type, 'url': link.url})
              .toList(),
      'skills': portfolio.skills,
      'tags': portfolio.tags,
      'languages': portfolio.languages,
      'defaultLocale': portfolio.defaultLocale,
    };
  }

  @override
  Future<void> createPortfolio(PortfolioModel portfolio) async {
    final docRef = FirebaseFirestore.instance.collection('portfolios').doc();

    final portfolioData = _portfolioToFirestore(portfolio);

    await _firestoreService.setDocument(
      collection: 'portfolios',
      docId: docRef.id,
      data: portfolioData,
    );
  }

  @override
  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    final portfolioData = _portfolioToFirestore(
      portfolio.copyWith(updatedAt: DateTime.now()),
    );

    await _firestoreService.updateDocument(
      collection: 'portfolios',
      docId: portfolio.id,
      data: portfolioData,
    );
  }

  @override
  Future<void> deletePortfolio(String portfolioId) async {
    await _firestoreService.deleteDocument(
      collection: 'portfolios',
      docId: portfolioId,
    );
  }

  @override
  Future<bool> isDomainAvailable(String domain) async {
    final portfolio = await getPortfolioByDomain(domain);
    return portfolio == null;
  }

  @override
  Future<void> addPortfolioToUser({
    required String userId,
    required String domain,
  }) async {
    final userDoc = await _firestoreService.getDocument(
      collection: 'users',
      docId: userId,
    );

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final portfolios = List<String>.from(userData['portfolios'] ?? []);

      if (!portfolios.contains(domain)) {
        portfolios.add(domain);

        await _firestoreService.updateDocument(
          collection: 'users',
          docId: userId,
          data: {'portfolios': portfolios},
        );
      }
    }
  }

  @override
  Future<void> removePortfolioFromUser({
    required String userId,
    required String domain,
  }) async {
    final userDoc = await _firestoreService.getDocument(
      collection: 'users',
      docId: userId,
    );

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final portfolios = List<String>.from(userData['portfolios'] ?? []);

      portfolios.remove(domain);

      await _firestoreService.updateDocument(
        collection: 'users',
        docId: userId,
        data: {'portfolios': portfolios},
      );
    }
  }
}
