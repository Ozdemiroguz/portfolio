import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../shared/domain/models/app_model.dart';
import '../providers/app_provider.dart';
import 'app_card.dart';
import 'create_app_dialog.dart';

class BottomAppsSection extends ConsumerWidget {
  final String portfolioId;

  const BottomAppsSection({super.key, required this.portfolioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomAppsAsync = ref.watch(bottomAppsProvider(portfolioId));

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
                  'bottom_apps_section_title'.tr(ref),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateAppDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: Text('add_app'.tr(ref)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            bottomAppsAsync.when(
              data: (apps) {
                if (apps.isEmpty) {
                  return _buildEmptyState(context, ref);
                }
                return _buildAppsList(context, ref, apps);
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
                            'error_loading_apps'.tr(ref),
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
                                  bottomAppsProvider(portfolioId),
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
          Icon(Icons.keyboard_arrow_up, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_bottom_apps_title'.tr(ref),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'no_bottom_apps_description'.tr(ref),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCreateAppDialog(context, ref),
            icon: const Icon(Icons.add),
            label: Text('create_first_app'.tr(ref)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppsList(
    BuildContext context,
    WidgetRef ref,
    List<AppModel> apps,
  ) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      onReorder:
          (oldIndex, newIndex) => _reorderApps(ref, apps, oldIndex, newIndex),
      itemBuilder: (context, index) {
        final app = apps[index];
        return AppCard(
          key: ValueKey(app.id),
          app: app,
          portfolioId: portfolioId,
          location: 'bottom',
          onEdit: () => _showEditAppDialog(context, ref, app),
          onDelete: () => _deleteApp(ref, app),
        );
      },
    );
  }

  void _showCreateAppDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) =>
              CreateAppDialog(portfolioId: portfolioId, location: 'bottom'),
    );
  }

  void _showEditAppDialog(BuildContext context, WidgetRef ref, AppModel app) {
    showDialog(
      context: context,
      builder:
          (context) => CreateAppDialog(
            portfolioId: portfolioId,
            location: 'bottom',
            existingApp: app,
          ),
    );
  }

  void _reorderApps(
    WidgetRef ref,
    List<AppModel> apps,
    int oldIndex,
    int newIndex,
  ) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final reorderedApps = List<AppModel>.from(apps);
    final app = reorderedApps.removeAt(oldIndex);
    reorderedApps.insert(newIndex, app);

    final appIds = reorderedApps.map((app) => app.id).toList();
    ref
        .read(appNotifierProvider.notifier)
        .reorderApps(portfolioId, appIds, 'bottom');
  }

  void _deleteApp(WidgetRef ref, AppModel app) {
    ref.read(appNotifierProvider.notifier).deleteBottomApp(portfolioId, app.id);
  }
}
