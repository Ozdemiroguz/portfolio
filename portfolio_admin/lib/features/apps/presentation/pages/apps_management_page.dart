import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../providers/app_provider.dart';
import '../widgets/home_apps_section.dart';
import '../widgets/folders_section.dart';
import '../widgets/bottom_apps_section.dart';

@RoutePage()
class AppsManagementPage extends ConsumerWidget {
  final String portfolioId;

  const AppsManagementPage({super.key, @pathParam required this.portfolioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('apps_management_title'.tr(ref)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sayfa açıklaması
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'apps_management_info_title'.tr(ref),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'apps_management_info_description'.tr(ref),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Ana Ekran Uygulamaları
            Text(
              'home_apps_title'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'home_apps_description'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            HomeAppsSection(portfolioId: portfolioId),

            const SizedBox(height: 32),

            // Klasörler
            Text(
              'folders_title'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'folders_description'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            FoldersSection(portfolioId: portfolioId),

            const SizedBox(height: 32),

            // Alt Panel Uygulamaları
            Text(
              'bottom_apps_title'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'bottom_apps_description'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            BottomAppsSection(portfolioId: portfolioId),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
