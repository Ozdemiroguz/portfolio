import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../shared/domain/models/app_model.dart';
import '../providers/app_provider.dart';
import 'app_card.dart';
import 'create_app_dialog.dart';

class FolderDetailDialog extends ConsumerWidget {
  final FolderModel folder;
  final String portfolioId;

  const FolderDetailDialog({
    super.key,
    required this.folder,
    required this.portfolioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderAppsAsync = ref.watch(
      folderAppsProvider((portfolioId, folder.id)),
    );

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          children: [
            _buildHeader(context, ref),
            Expanded(
              child: folderAppsAsync.when(
                data: (apps) => _buildContent(context, ref, apps),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorState(context, ref, error),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    Color folderColor;
    try {
      folderColor = Color(int.parse(folder.color.replaceAll('#', '0xFF')));
    } catch (e) {
      folderColor = Theme.of(context).primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: folderColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(
              _getIconFromName(folder.icon),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (folder.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    folder.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${folder.appIds.length} uygulama',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<AppModel> apps,
  ) {
    if (apps.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return Column(
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Klasör İçeriği',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showCreateAppDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Uygulama Ekle'),
              ),
            ],
          ),
        ),
        // Apps list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return AppCard(
                key: ValueKey(app.id),
                app: app,
                portfolioId: portfolioId,
                location: folder.id,
                onEdit: () => _showEditAppDialog(context, ref, app),
                onDelete: () => _removeAppFromFolder(ref, app),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Klasör Boş',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu klasörde henüz uygulama yok.\nİlk uygulamanızı eklemek için aşağıdaki butona tıklayın.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateAppDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('İlk Uygulamayı Ekle'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text('Hata', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                () => ref.invalidate(
                  folderAppsProvider((portfolioId, folder.id)),
                ),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    final iconMap = {
      'folder': Icons.folder,
      'work': Icons.work,
      'school': Icons.school,
      'business': Icons.business_center,
      'code': Icons.code,
      'design': Icons.design_services,
      'photo': Icons.photo,
      'music': Icons.music_note,
      'video': Icons.video_camera_back,
      'game': Icons.games,
      'book': Icons.book,
      'star': Icons.star,
    };

    return iconMap[iconName] ?? Icons.folder;
  }

  void _showCreateAppDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => CreateAppDialog(
            portfolioId: portfolioId,
            location: folder.id, // folder ID as location
          ),
    );
  }

  void _showEditAppDialog(BuildContext context, WidgetRef ref, AppModel app) {
    showDialog(
      context: context,
      builder:
          (context) => CreateAppDialog(
            portfolioId: portfolioId,
            location: folder.id,
            existingApp: app,
          ),
    );
  }

  void _removeAppFromFolder(WidgetRef ref, AppModel app) {
    ref
        .read(appNotifierProvider.notifier)
        .deleteFolderApp(portfolioId, folder.id, app.id);
  }
}
