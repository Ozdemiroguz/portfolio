import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../shared/domain/models/app_model.dart';
import '../providers/app_provider.dart';
import 'create_folder_dialog.dart';
import 'folder_card.dart';
import 'folder_detail_dialog.dart';

class FoldersSection extends ConsumerWidget {
  final String portfolioId;

  const FoldersSection({super.key, required this.portfolioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider(portfolioId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'folders_section_title'.tr(ref),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateFolderDialog(context, ref),
                  icon: const Icon(Icons.folder_open),
                  label: Text('add_folder'.tr(ref)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            foldersAsync.when(
              data: (folders) {
                if (folders.isEmpty) {
                  return _buildEmptyState(context, ref);
                }
                return _buildFoldersList(context, ref, folders);
              },
              loading:
                  () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              error:
                  (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'error_loading_folders'.tr(ref),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
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
                                  foldersProvider(portfolioId),
                                ),
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.folder, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_folders_title'.tr(ref),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'no_folders_description'.tr(ref),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCreateFolderDialog(context, ref),
            icon: const Icon(Icons.folder_open),
            label: Text('create_first_folder'.tr(ref)),
          ),
        ],
      ),
    );
  }

  Widget _buildFoldersList(
    BuildContext context,
    WidgetRef ref,
    List<FolderModel> folders,
  ) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      onReorder:
          (oldIndex, newIndex) =>
              _reorderFolders(ref, folders, oldIndex, newIndex),
      itemBuilder: (context, index) {
        final folder = folders[index];
        return FolderCard(
          key: ValueKey(folder.id),
          folder: folder,
          portfolioId: portfolioId,
          onEdit: () => _showEditFolderDialog(context, ref, folder),
          onDelete: () => _deleteFolder(ref, folder),
          onTap: () => _openFolder(context, folder),
        );
      },
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CreateFolderDialog(portfolioId: portfolioId),
    );
  }

  void _showEditFolderDialog(
    BuildContext context,
    WidgetRef ref,
    FolderModel folder,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => CreateFolderDialog(
            portfolioId: portfolioId,
            existingFolder: folder,
          ),
    );
  }

  void _reorderFolders(
    WidgetRef ref,
    List<FolderModel> folders,
    int oldIndex,
    int newIndex,
  ) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final reorderedFolders = List<FolderModel>.from(folders);
    final folder = reorderedFolders.removeAt(oldIndex);
    reorderedFolders.insert(newIndex, folder);

    final folderIds = reorderedFolders.map((folder) => folder.id).toList();
    ref
        .read(appNotifierProvider.notifier)
        .reorderFolders(portfolioId, folderIds);
  }

  void _deleteFolder(WidgetRef ref, FolderModel folder) {
    ref.read(appNotifierProvider.notifier).deleteFolder(portfolioId, folder.id);
  }

  void _openFolder(BuildContext context, FolderModel folder) {
    showDialog(
      context: context,
      builder:
          (context) =>
              FolderDetailDialog(folder: folder, portfolioId: portfolioId),
    );
  }
}
