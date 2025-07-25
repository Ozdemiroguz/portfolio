import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../shared/domain/models/app_model.dart';

class AppCard extends ConsumerWidget {
  final AppModel app;
  final String portfolioId;
  final String location;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AppCard({
    super.key,
    required this.app,
    required this.portfolioId,
    required this.location,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildAppIcon(context),
        title: Text(
          app.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (app.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                app.description,
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
                _buildTypeChip(context),
                const SizedBox(width: 8),
                _buildStatusChip(context),
                if (app.images.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _buildImageCountChip(context),
                ],
              ],
            ),
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
        isThreeLine: app.description.isNotEmpty,
      ),
    );
  }

  Widget _buildAppIcon(BuildContext context) {
    if (app.icon.isNotEmpty) {
      // URL ise network image, değilse icon olarak yorumla
      if (app.icon.startsWith('http')) {
        return CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(app.icon),
          onBackgroundImageError: (exception, stackTrace) {
            // Hata durumunda default icon göster
          },
          child: app.icon.startsWith('http') ? null : _getDefaultIcon(),
        );
      } else {
        // Icon name olarak yorumla
        return CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).primaryColor,
          child: _getIconFromName(app.icon),
        );
      }
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).primaryColor,
      child: _getDefaultIcon(),
    );
  }

  Widget _getDefaultIcon() {
    switch (app.type) {
      case 'project':
        return const Icon(Icons.work, color: Colors.white, size: 20);
      case 'education':
        return const Icon(Icons.school, color: Colors.white, size: 20);
      case 'career':
        return const Icon(Icons.business_center, color: Colors.white, size: 20);
      case 'contact':
        return const Icon(Icons.contact_mail, color: Colors.white, size: 20);
      case 'achievement':
        return const Icon(Icons.emoji_events, color: Colors.white, size: 20);
      case 'about':
        return const Icon(Icons.person, color: Colors.white, size: 20);
      case 'reference':
        return const Icon(Icons.recommend, color: Colors.white, size: 20);
      case 'camera':
        return const Icon(Icons.camera_alt, color: Colors.white, size: 20);
      case 'phone':
        return const Icon(Icons.phone, color: Colors.white, size: 20);
      case 'messages':
        return const Icon(Icons.message, color: Colors.white, size: 20);
      case 'game1':
        return const Icon(Icons.sports_esports, color: Colors.white, size: 20);
      case 'game2':
        return const Icon(Icons.gamepad, color: Colors.white, size: 20);
      case 'game3':
        return const Icon(Icons.casino, color: Colors.white, size: 20);
      case 'custom1':
        return const Icon(Icons.extension, color: Colors.white, size: 20);
      case 'custom2':
        return const Icon(Icons.apps, color: Colors.white, size: 20);
      case 'custom3':
        return const Icon(Icons.widgets, color: Colors.white, size: 20);
      default:
        return const Icon(Icons.apps, color: Colors.white, size: 20);
    }
  }

  Widget _getIconFromName(String iconName) {
    // Basit icon mapping - daha sonra genişletilebilir
    final iconMap = {
      'work': Icons.work,
      'school': Icons.school,
      'business': Icons.business_center,
      'contact': Icons.contact_mail,
      'trophy': Icons.emoji_events,
      'person': Icons.person,
      'star': Icons.star,
      'code': Icons.code,
      'design': Icons.design_services,
      'camera': Icons.camera_alt,
      'music': Icons.music_note,
      'video': Icons.video_camera_back,
      'web': Icons.web,
      'mobile': Icons.phone_android,
    };

    return Icon(iconMap[iconName] ?? Icons.apps, color: Colors.white, size: 20);
  }

  Widget _buildTypeChip(BuildContext context) {
    final typeColors = {
      'project': Colors.blue,
      'education': Colors.green,
      'career': Colors.purple,
      'contact': Colors.orange,
      'achievement': Colors.amber,
      'about': Colors.teal,
      'reference': Colors.indigo,
      'camera': Colors.pink,
      'phone': Colors.cyan,
      'messages': Colors.lightGreen,
      'game1': Colors.red,
      'game2': Colors.deepOrange,
      'game3': Colors.deepPurple,
      'custom1': Colors.brown,
      'custom2': Colors.blueGrey,
      'custom3': Colors.grey,
    };

    final typeNames = {
      'project': 'Proje',
      'education': 'Eğitim',
      'career': 'Kariyer',
      'contact': 'İletişim',
      'achievement': 'Başarı',
      'about': 'Hakkımda',
      'reference': 'Referans',
      'camera': 'Kamera',
      'phone': 'Telefon',
      'messages': 'Mesajlar',
      'game1': 'Oyun 1',
      'game2': 'Oyun 2',
      'game3': 'Oyun 3',
      'custom1': 'Özel 1',
      'custom2': 'Özel 2',
      'custom3': 'Özel 3',
    };

    return Chip(
      label: Text(
        typeNames[app.type] ?? app.type,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: typeColors[app.type] ?? Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Chip(
      label: Text(
        app.isActive ? 'Aktif' : 'Pasif',
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: app.isActive ? Colors.green : Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildImageCountChip(BuildContext context) {
    return Chip(
      label: Text(
        '${app.images.length} 📷',
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('confirm_delete'.tr(ref)),
            content: Text(
              'Bu uygulamayı silmek istediğinizden emin misiniz?\n\n"${app.title}"',
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
