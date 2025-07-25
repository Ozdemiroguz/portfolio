import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/utils/localization_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/portfolio_provider.dart';

@RoutePage()
class PortfolioListPage extends ConsumerWidget {
  const PortfolioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPortfolios = ref.watch(userPortfoliosProvider);
    final portfolioState = ref.watch(portfolioNotifierProvider);

    ref.listen(portfolioNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('İşlem başarıyla tamamlandı'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('portfolio.portfolios'.tr(ref)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
            },
            tooltip: 'auth.logout'.tr(ref),
          ),
        ],
      ),
      body: userPortfolios.when(
        data: (portfolios) {
          if (portfolios.isEmpty) {
            return _EmptyPortfolioList(ref: ref);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userPortfoliosProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: portfolios.length,
              itemBuilder: (context, index) {
                final portfolio = portfolios[index];
                return _PortfolioCard(portfolio: portfolio, ref: ref);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hata: $error',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(userPortfoliosProvider);
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            portfolioState.isLoading
                ? null
                : () => _showCreatePortfolioDialog(context, ref),
        icon:
            portfolioState.isLoading
                ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Icon(Icons.add),
        label: Text('portfolio.createPortfolio'.tr(ref)),
      ),
    );
  }

  void _showCreatePortfolioDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreatePortfolioDialog(ref: ref),
    );
  }
}

class _EmptyPortfolioList extends StatelessWidget {
  final WidgetRef ref;

  const _EmptyPortfolioList({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'Henüz portföyünüz yok',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'İlk portföyünüzü oluşturmak için + butonuna tıklayın',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final portfolio;
  final WidgetRef ref;

  const _PortfolioCard({required this.portfolio, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        portfolio.title.isNotEmpty
                            ? portfolio.title
                            : portfolio.domain,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${portfolio.domain}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (portfolio.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          portfolio.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        portfolio.isPublic
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    portfolio.isPublic ? 'Yayında' : 'Taslak',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: portfolio.isPublic ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Portföyü görüntüle
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Görüntüle'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.router.pushNamed(
                        '/portfolio/${portfolio.domain}',
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text('Düzenle'.tr(ref)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeleteDialog(context, portfolio),
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, portfolio) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Portföyü Sil'),
            content: Text(
              '${portfolio.title.isNotEmpty ? portfolio.title : portfolio.domain} portföyünü silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref
                      .read(portfolioNotifierProvider.notifier)
                      .deletePortfolio(portfolio);
                },
                child: const Text('Sil'),
              ),
            ],
          ),
    );
  }
}

class _CreatePortfolioDialog extends StatefulWidget {
  final WidgetRef ref;

  const _CreatePortfolioDialog({required this.ref});

  @override
  State<_CreatePortfolioDialog> createState() => _CreatePortfolioDialogState();
}

class _CreatePortfolioDialogState extends State<_CreatePortfolioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCheckingDomain = false;

  @override
  void dispose() {
    _domainController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('portfolio.createPortfolio'.tr(widget.ref)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _domainController,
                decoration: InputDecoration(
                  labelText: 'portfolio.domain'.tr(widget.ref),
                  hintText: 'ornek-domain',
                  helperText: 'Sadece harf, rakam ve tire (-) kullanın',
                  suffixIcon:
                      _isCheckingDomain
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Domain adı gerekli';
                  }
                  if (value.contains(' ')) {
                    return 'Domain adı boşluk içeremez';
                  }
                  if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                    return 'Sadece küçük harf, rakam ve tire kullanın';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length >= 3) {
                    _checkDomainAvailability(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'portfolio.title'.tr(widget.ref),
                  hintText: 'Oğuzhan Özdemir | Mobil Geliştirici',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'portfolio.description'.tr(widget.ref),
                  hintText: 'Flutter ile geliştirdiğim projeler...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Açıklama gerekli';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common.cancel'.tr(widget.ref)),
        ),
        ElevatedButton(
          onPressed: _handleCreate,
          child: Text('common.save'.tr(widget.ref)),
        ),
      ],
    );
  }

  Future<void> _checkDomainAvailability(String domain) async {
    setState(() {
      _isCheckingDomain = true;
    });

    try {
      final isAvailable = await widget.ref
          .read(portfolioNotifierProvider.notifier)
          .isDomainAvailable(domain);

      if (mounted) {
        setState(() {
          _isCheckingDomain = false;
        });

        if (!isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bu domain adı zaten kullanılıyor'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingDomain = false;
        });
      }
    }
  }

  Future<void> _handleCreate() async {
    if (_formKey.currentState!.validate() && !_isCheckingDomain) {
      try {
        await widget.ref
            .read(portfolioNotifierProvider.notifier)
            .createPortfolio(
              domain: _domainController.text.trim().toLowerCase(),
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
            );

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Hata provider listener'da yakalanacak
      }
    }
  }
}
