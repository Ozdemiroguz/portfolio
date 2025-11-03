import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/download_helpers.dart';
import 'widgets/pdf_viewer_widget.dart';

/// CV screen
/// Displays resume/CV information and PDF viewer
class CvScreen extends StatelessWidget {
  final AppEntity app;

  const CvScreen({super.key, required this.app});

  String? _getPdfUrl() {
    if (app.data != null && app.data is Map<String, dynamic>) {
      final data = app.data as Map<String, dynamic>;
      return data['pdfUrl'] as String?;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    final pdfUrl = _getPdfUrl();
    final currentDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

    return Container(
      color: AppColors.backgroundDark1,
      child: SafeArea(
        child: pdfUrl != null
            ? Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                      vertical: AppSizes.paddingLg + 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.withOpacity(Colors.white, 0.05),
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.withOpacity(Colors.white, 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Geri butonu için boşluk (AppScreenWrapperWidget'daki geri butonu için)
                        const SizedBox(width: 60),
                        // Tarih - sol taraf
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('cv.title'),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentDate,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // İndirme butonu - sağ taraf
                        GestureDetector(
                          onTap: () async {
                            final success = await DownloadHelpers.downloadPdf(
                              pdfUrl,
                              fileName: 'Oguzhan-Ozdemir-CV.pdf',
                            );
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: AppSizes.spacingXs),
                                      Text(
                                        tr('cv.downloadStarted'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                  margin: const EdgeInsets.only(
                                    bottom: 20,
                                    left: 16,
                                    right: 16,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingMd,
                              vertical: AppSizes.paddingSm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: AppSizes.spacingXs),
                                Text(
                                  tr('cv.download'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // PDF Viewer
                  Expanded(
                    child: PdfViewerWidget(pdfUrl: pdfUrl),
                  ),
                ],
              )
            : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        tr('cv.title'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr('cv.subtitle'),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Info section
                      _buildInfoCard(
                        icon: Icons.person,
                        title: tr('cv.personalInfo'),
                        items: [
                          tr('cv.name'),
                          tr('cv.position'),
                          tr('cv.location'),
                          tr('cv.email'),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Skills section
                      _buildInfoCard(
                        icon: Icons.star,
                        title: tr('cv.skills'),
                        items: [
                          'Flutter',
                          'Dart',
                          'Swift',
                          'Node.js',
                          'Firebase',
                          'Clean Architecture',
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Experience section
                      _buildInfoCard(
                        icon: Icons.work,
                        title: tr('cv.experience'),
                        items: [
                          tr('cv.experience1'),
                          tr('cv.experience2'),
                          tr('cv.experience3'),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Education section
                      _buildInfoCard(
                        icon: Icons.school,
                        title: tr('cv.education'),
                        items: [tr('cv.education1')],
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
