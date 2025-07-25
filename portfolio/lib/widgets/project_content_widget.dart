import 'package:flutter/material.dart';
import '../models/app.dart';
import 'glassmorphism_link_widget.dart';
import 'date_section_widget.dart';

class ProjectContentWidget extends StatelessWidget {
  final App openApp;
  final ScrollController scrollController;

  const ProjectContentWidget({
    super.key,
    required this.openApp,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? projectData = openApp.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Proje verileri (her zaman göster)
        if (projectData.isNotEmpty)
          _buildSingleProjectSection(projectData)
        else
          _buildEmptyProjectDataSection(),
      ],
    );
  }

  Widget _buildSingleProjectSection(Map<String, dynamic> project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PROJE KARTLARI - MODERN DARK THEME
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                openApp.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Açıklama
              Text(
                openApp.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),

              // Linkler
              if (project['links'] != null &&
                  (project['links'] as List).isNotEmpty) ...[
                GlassmorphismLinkWidget(links: project['links']),
                const SizedBox(height: 20),
              ],

              // Detaylar
              if (project['role'] != null ||
                  project['teamSize'] != null ||
                  project['status'] != null ||
                  project['startDate'] != null ||
                  project['endDate'] != null ||
                  project['ownProject'] != null) ...[
                _buildModernInfoSection([
                  if (project['role'] != null) 'Role: ${project['role']}',
                  if (project['teamSize'] != null)
                    'Team: ${project['teamSize']}',
                  if (project['status'] != null)
                    'Status: ${project['status'].toString().toUpperCase()}',
                  if (project['startDate'] != null)
                    'Started: ${_formatDate(project['startDate'])}',
                  if (project['endDate'] != null)
                    'Ended: ${_formatDate(project['endDate'])}',
                  if (project['ownProject'] != null)
                    project['ownProject'] == true
                        ? 'Personal Project'
                        : 'Client Project',
                ]),
                const SizedBox(height: 20),
              ],

              // Teknolojiler - MODERN TAGS
              if (project['technologies'] != null &&
                  (project['technologies'] as List).isNotEmpty) ...[
                _buildModernTechSection(
                  (project['technologies'] as List)
                      .map((tech) => tech.toString())
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Özellikler - MODERN LIST
              if (project['features'] != null &&
                  (project['features'] as List).isNotEmpty) ...[
                _buildModernFeaturesSection(
                  (project['features'] as List)
                      .map((feature) => feature.toString())
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoSection(List<String> items) {
    // Tarih bilgilerini ayır
    String? startedDate;
    String? endedDate;
    List<String> otherItems = [];

    for (String item in items) {
      if (item.toLowerCase().startsWith('started:')) {
        startedDate = item.substring(8).trim();
      } else if (item.toLowerCase().startsWith('ended:')) {
        endedDate = item.substring(6).trim();
      } else {
        otherItems.add(item);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DETAILS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              // Diğer itemları göster
              ...otherItems.map((item) => _buildDetailItem(item)),
              // Tarih bilgilerini yan yana göster
              if (startedDate != null || endedDate != null)
                DateSectionWidget(
                  startedDate: startedDate,
                  endedDate: endedDate,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String item) {
    // Started ve Ended tarihlerini yan yana göstermek için özel durum
    if (item.toLowerCase().startsWith('started:') ||
        item.toLowerCase().startsWith('ended:')) {
      return const SizedBox.shrink(); // Bu itemları ayrı ayrı gösterme, yan yana göstereceğiz
    }

    // Status için özel renkli tasarım
    if (item.toLowerCase().startsWith('status:')) {
      String status = item.substring(7).trim().toUpperCase();
      Color statusColor = _getStatusColor(status);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 12),
            Text(
              'Status: ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  color: statusColor.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Role için özel tasarım
    if (item.toLowerCase().startsWith('role:')) {
      String role = item.substring(5).trim();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              color: Colors.grey.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 12),
            Text(
              'Role: ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            Expanded(
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Team için özel tasarım
    if (item.toLowerCase().startsWith('team:')) {
      String team = item.substring(5).trim();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.group_outlined,
              color: Colors.grey.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 12),
            Text(
              'Team Size: ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Text(
                '$team people',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Personal Project için özel tasarım
    if (item.toLowerCase().contains('personal project') ||
        item.toLowerCase().contains('client project')) {
      bool isPersonal = item.toLowerCase().contains('personal');
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              isPersonal ? Icons.person : Icons.business,
              color: Colors.grey.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    isPersonal
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isPersonal
                          ? Colors.orange.withOpacity(0.3)
                          : Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Text(
                isPersonal ? 'Personal Project' : 'Client Project',
                style: TextStyle(
                  fontSize: 11,
                  color: isPersonal ? Colors.orange : Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Diğer itemler için varsayılan tasarım
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTechSection(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TECHNOLOGIES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items.map((tech) => _buildTechTag(tech)).toList(),
        ),
      ],
    );
  }

  Widget _buildTechTag(String tech) {
    // Teknoloji türüne göre hafif renk belirleme
    Color tagColor = _getTechColor(tech.toLowerCase());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTechIcon(tech.toLowerCase()),
            color: tagColor.withOpacity(0.8),
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            tech,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTechColor(String tech) {
    if (tech.contains('flutter') || tech.contains('dart')) {
      return Colors.blue;
    }
    if (tech.contains('react') ||
        tech.contains('javascript') ||
        tech.contains('js')) {
      return Colors.yellow;
    }
    if (tech.contains('python')) {
      return Colors.green;
    }
    if (tech.contains('java')) {
      return Colors.orange;
    }
    if (tech.contains('swift') || tech.contains('ios')) {
      return Colors.grey;
    }
    if (tech.contains('kotlin') || tech.contains('android')) {
      return Colors.green;
    }
    if (tech.contains('node') || tech.contains('express')) {
      return Colors.green;
    }
    if (tech.contains('firebase') || tech.contains('database')) {
      return Colors.orange;
    }
    if (tech.contains('api') || tech.contains('rest')) {
      return Colors.purple;
    }
    return Colors.indigo;
  }

  IconData _getTechIcon(String tech) {
    if (tech.contains('flutter') || tech.contains('dart')) {
      return Icons.phone_android;
    }
    if (tech.contains('react') || tech.contains('javascript')) {
      return Icons.web;
    }
    if (tech.contains('python')) {
      return Icons.code;
    }
    if (tech.contains('java')) {
      return Icons.coffee;
    }
    if (tech.contains('swift') || tech.contains('ios')) {
      return Icons.phone_iphone;
    }
    if (tech.contains('android')) {
      return Icons.android;
    }
    if (tech.contains('database')) {
      return Icons.storage;
    }
    if (tech.contains('api')) {
      return Icons.api;
    }
    return Icons.code;
  }

  Widget _buildModernFeaturesSection(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FEATURES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children:
                items.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  return _buildFeatureItem(item, index);
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2, right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(
              Icons.check,
              color: Colors.green.withOpacity(0.8),
              size: 12,
            ),
          ),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProjectDataSection() {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            openApp.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Açıklama
          Text(
            openApp.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),

          // Resimler bölümü
          const Text(
            'Project Screenshots:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Center(
              child: Text(
                'No images available',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Teknolojiler bölümü
          const Text(
            'Technologies:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No technologies listed',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Özellikler bölümü
          const Text(
            'Features:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: Colors.grey[400])),
              Expanded(
                child: Text(
                  'No features listed',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Durum ve tarih bölümü
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NO STATUS',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Started: No date',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Linkler bölümü
          const GlassmorphismLinkWidget(links: null),
        ],
      ),
    );
  }

  // Helper metodlar
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
      case 'in progress':
        return Colors.orange;
      case 'planned':
        return Colors.blue;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic dateValue) {
    try {
      DateTime date;
      if (dateValue is DateTime) {
        date = dateValue;
      } else if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else {
        return dateValue.toString();
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateValue.toString();
    }
  }
}
