import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../shared/domain/models/app_model.dart';
import '../providers/app_provider.dart';
import 'create_app_dialog.dart';

class FolderCard extends ConsumerWidget {
  final FolderModel folder;
  final String portfolioId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const FolderCard({
    super.key,
    required this.folder,
    required this.portfolioId,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildFolderIcon(context),
        title: Text(
          folder.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (folder.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                folder.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAppCountChip(context),
                const SizedBox(width: 8),
                _buildStatusChip(context),
                const Spacer(),
                _buildAddAppButton(context, ref),
              ],
            ),
            if (folder.appIds.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildAppsPreview(context, ref),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'edit'.tr(ref),
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context, ref),
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              tooltip: 'delete'.tr(ref),
            ),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
        onTap: onTap,
        isThreeLine: folder.description.isNotEmpty || folder.appIds.isNotEmpty,
      ),
    );
  }

  Widget _buildFolderIcon(BuildContext context) {
    Color folderColor;
    try {
      folderColor = Color(int.parse(folder.color.replaceAll('#', '0xFF')));
    } catch (e) {
      folderColor = Theme.of(context).primaryColor;
    }

    if (folder.icon.isNotEmpty) {
      // URL ise network image, değilse icon olarak yorumla
      if (folder.icon.startsWith('http')) {
        return CircleAvatar(
          radius: 24,
          backgroundColor: folderColor,
          backgroundImage: NetworkImage(folder.icon),
          onBackgroundImageError: (exception, stackTrace) {
            // Hata durumunda default icon göster
          },
        );
      } else {
        // Icon name olarak yorumla
        return CircleAvatar(
          radius: 24,
          backgroundColor: folderColor,
          child: _getIconFromName(folder.icon),
        );
      }
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: folderColor,
      child: const Icon(Icons.folder, color: Colors.white, size: 20),
    );
  }

  Widget _getIconFromName(String iconName) {
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

    return Icon(
      iconMap[iconName] ?? Icons.folder,
      color: Colors.white,
      size: 20,
    );
  }

  Widget _buildAppCountChip(BuildContext context) {
    return Chip(
      label: Text(
        '${folder.appIds.length} uygulama',
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Chip(
      label: Text(
        folder.isActive ? 'Aktif' : 'Pasif',
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: folder.isActive ? Colors.green : Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildAddAppButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 28,
      child: ElevatedButton.icon(
        onPressed: () => _showCreateAppDialog(context, ref),
        icon: const Icon(Icons.add, size: 14),
        label: const Text('App Ekle', style: TextStyle(fontSize: 11)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  Widget _buildAppsPreview(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(folderAppsProvider((portfolioId, folder.id)));

    return appsAsync.when(
      data: (apps) {
        if (apps.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Klasör İçeriği:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children:
                    apps.take(3).map((app) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(app.type),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            app.title,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList()
                      ..addAll(
                        apps.length > 3
                            ? [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '+${apps.length - 3}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ]
                            : [],
                      ),
              ),
            ],
          ),
        );
      },
      loading:
          () => const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 1),
          ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Color _getTypeColor(String type) {
    final typeColors = {
      'project': Colors.blue,
      'education': Colors.green,
      'career': Colors.purple,
      'contact': Colors.orange,
      'achievement': Colors.amber,
      'about': Colors.teal,
      'reference': Colors.indigo,
    };
    return typeColors[type] ?? Colors.grey;
  }

  void _showCreateAppDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) =>
              CreateAppDialog(portfolioId: portfolioId, location: folder.id),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('confirm_delete'.tr(ref)),
            content: Text(
              'Bu klasörü ve içindeki tüm uygulamaları silmek istediğinizden emin misiniz?\n\n"${folder.title}"\n\nBu işlem geri alınamaz.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('cancel'.tr(ref)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete?.call();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('delete'.tr(ref)),
              ),
            ],
          ),
    );
  }
}
