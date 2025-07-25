import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/edit_basic_info_dialog.dart';
import '../widgets/edit_social_links_dialog.dart';
import '../widgets/edit_skills_dialog.dart';
import '../widgets/edit_theme_dialog.dart';
import '../widgets/edit_languages_dialog.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/theme/portfolio_theme.dart';
import '../../../../core/router/app_router.dart';

@RoutePage()
class PortfolioDetailPage extends ConsumerWidget {
  final String domain;

  const PortfolioDetailPage({super.key, @pathParam required this.domain});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioByDomainProvider(domain));

    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Düzenle'.tr(ref)),
        centerTitle: true,
        elevation: 0,
      ),
      body: portfolioAsync.when(
        data: (portfolio) {
          if (portfolio == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Portfolio bulunamadı'.tr(ref),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bu domain adına ait portfolio mevcut değil'.tr(ref),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.router.maybePop(),
                    icon: const Icon(Icons.arrow_back),
                    label: Text('Geri Dön'.tr(ref)),
                  ),
                ],
              ),
            );
          }

          return _PortfolioDetailContent(portfolio: portfolio);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Hata'.tr(ref),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(portfolioByDomainProvider(domain));
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text('Tekrar Dene'.tr(ref)),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _PortfolioDetailContent extends ConsumerWidget {
  final PortfolioModel portfolio;

  const _PortfolioDetailContent({required this.portfolio});

  Future<void> _showBasicInfoDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => EditBasicInfoDialog(portfolio: portfolio),
    );
  }

  Future<void> _showSocialLinksDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => EditSocialLinksDialog(portfolio: portfolio),
    );
  }

  Future<void> _showSkillsDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => EditSkillsDialog(portfolio: portfolio),
    );
  }

  Future<void> _showThemeDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => EditThemeDialog(portfolio: portfolio),
    );
  }

  Future<void> _showLanguagesDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => EditLanguagesDialog(portfolio: portfolio),
    );
  }

  Future<void> _togglePublishStatus(BuildContext context, WidgetRef ref) async {
    try {
      final updatedPortfolio = portfolio.copyWith(
        isPublic: !portfolio.isPublic,
      );
      await ref
          .read(portfolioNotifierProvider.notifier)
          .updatePortfolio(updatedPortfolio);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            portfolio.isPublic
                ? 'Portfolio yayından kaldırıldı'
                : 'Portfolio yayınlandı',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $error'), backgroundColor: Colors.red),
      );
    }
  }

  String _getLanguageDisplayName(String code) {
    final languages = {
      'tr': '🇹🇷 Türkçe',
      'en': '🇺🇸 İngilizce',
      'de': '🇩🇪 Almanca',
      'fr': '🇫🇷 Fransızca',
      'es': '🇪🇸 İspanyolca',
      'it': '🇮🇹 İtalyanca',
      'pt': '🇵🇹 Portekizce',
      'ru': '🇷🇺 Rusça',
      'ja': '🇯🇵 Japonca',
      'ko': '🇰🇷 Korece',
      'zh': '🇨🇳 Çince',
      'ar': '🇸🇦 Arapça',
    };
    return languages[code] ?? code.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildQuickActionsCard(context, ref),
          const SizedBox(height: 16),
          _buildBasicInfoCard(context, ref),
          const SizedBox(height: 16),
          _buildThemeCard(context, ref),
          const SizedBox(height: 16),
          _buildSocialLinksCard(context, ref),
          const SizedBox(height: 16),
          _buildSkillsCard(context, ref),
          const SizedBox(height: 16),
          _buildLanguagesCard(context, ref),
          const SizedBox(height: 16),
          _buildPublishCard(context, ref),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.dashboard_customize),
                const SizedBox(width: 8),
                Text(
                  'Portföy Yönetimi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.router.pushNamed(
                        '/portfolio/${portfolio.id}/apps',
                      );
                    },
                    icon: const Icon(Icons.apps),
                    label: const Text('Uygulama Yönetimi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Portfolio preview
                    },
                    icon: const Icon(Icons.preview),
                    label: const Text('Önizleme'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).primaryColor,
              child:
                  portfolio.profilePhoto != null
                      ? ClipOval(
                        child: Image.network(
                          portfolio.profilePhoto!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                      : const Icon(Icons.person, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portfolio.title.isNotEmpty
                        ? portfolio.title
                        : portfolio.domain,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    portfolio.domain,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        portfolio.isPublic ? Icons.public : Icons.public_off,
                        size: 16,
                        color:
                            portfolio.isPublic ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        portfolio.isPublic ? 'Yayında' : 'Taslak',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              portfolio.isPublic ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 8),
                Text(
                  'Temel Bilgiler',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showBasicInfoDialog(context, ref),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'Başlık', portfolio.title),
            _buildInfoRow(context, 'Açıklama', portfolio.description),
            _buildInfoRow(context, 'Tip', portfolio.portfolioType),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette_outlined),
                const SizedBox(width: 8),
                Text(
                  'Tema Ayarları',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showThemeDialog(context, ref),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildColorBox(portfolio.theme.primaryColor),
                const SizedBox(width: 8),
                Text('Ana Renk'),
                const SizedBox(width: 24),
                _buildColorBox(portfolio.theme.accentColor),
                const SizedBox(width: 8),
                Text('Vurgu Rengi'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildColorBox(portfolio.theme.backgroundColor),
                const SizedBox(width: 8),
                Text('Arka Plan'),
                const SizedBox(width: 24),
                _buildColorBox(portfolio.theme.textColor),
                const SizedBox(width: 8),
                Text('Metin'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  portfolio.theme.mode == 'light'
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  size: 20,
                  color:
                      portfolio.theme.mode == 'light'
                          ? Colors.orange
                          : Colors.indigo,
                ),
                const SizedBox(width: 8),
                Text(
                  portfolio.theme.mode == 'light' ? 'Açık Tema' : 'Koyu Tema',
                  style: TextStyle(
                    color:
                        portfolio.theme.mode == 'light'
                            ? Colors.orange
                            : Colors.indigo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.link),
                const SizedBox(width: 8),
                Text(
                  'Sosyal Bağlantılar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showSocialLinksDialog(context, ref),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (portfolio.socialLinks.isEmpty)
              Text(
                'Henüz sosyal bağlantı eklenmemiş',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              )
            else
              ...portfolio.socialLinks.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildInfoRow(
                    context,
                    link.type,
                    link.url ?? 'Belirtilmemiş',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_outline),
                const SizedBox(width: 8),
                Text(
                  'Yetenekler & Etiketler',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showSkillsDialog(context, ref),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (portfolio.skills.isNotEmpty) ...[
              Text(
                'Yetenekler:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    portfolio.skills
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (portfolio.tags.isNotEmpty) ...[
              Text(
                'Etiketler:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    portfolio.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.grey[200],
                          ),
                        )
                        .toList(),
              ),
            ],
            if (portfolio.skills.isEmpty && portfolio.tags.isEmpty)
              Text(
                'Henüz yetenek veya etiket eklenmemiş',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagesCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language),
                const SizedBox(width: 8),
                Text(
                  'Dil Ayarları',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showLanguagesDialog(context, ref),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Varsayılan Dil',
              _getLanguageDisplayName(portfolio.defaultLocale),
            ),
            const SizedBox(height: 8),
            Text(
              'Desteklenen Diller:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  portfolio.languages
                      .map(
                        (lang) => Chip(
                          label: Text(_getLanguageDisplayName(lang)),
                          backgroundColor:
                              lang == portfolio.defaultLocale
                                  ? Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1)
                                  : Colors.grey[200],
                          side: BorderSide(
                            color:
                                lang == portfolio.defaultLocale
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[400]!,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  portfolio.isPublic ? Icons.public : Icons.public_off,
                  color: portfolio.isPublic ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Yayın Durumu',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              portfolio.isPublic
                  ? 'Portfolio şu anda yayında ve herkese açık.'
                  : 'Portfolio henüz yayında değil. Sadece siz görebilirsiniz.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _togglePublishStatus(context, ref),
                icon: Icon(
                  portfolio.isPublic ? Icons.public_off : Icons.public,
                ),
                label: Text(portfolio.isPublic ? 'Yayından Kaldır' : 'Yayınla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      portfolio.isPublic ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Belirtilmemiş',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: value.isNotEmpty ? null : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(String colorHex) {
    Color color;
    try {
      color = Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } catch (e) {
      color = Colors.grey;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
    );
  }
}
