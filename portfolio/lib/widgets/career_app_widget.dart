import 'package:flutter/material.dart';
import '../models/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareerAppWidget extends StatelessWidget {
  final App openApp;

  const CareerAppWidget({super.key, required this.openApp});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Üst boşluk - geri butonu için
          const SizedBox(height: 100),

          // Career içeriği
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCareerContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerContent() {
    Map<String, dynamic>? data = openApp.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık ve açıklama container'ı
        Container(
          width: double.infinity,
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
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Career Timeline
        _buildCareerTimeline(data),
      ],
    );
  }

  Widget _buildCareerTimeline(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return _buildEmptyState();
    }

    // Tek career objesi varsa (Firebase structure'a göre)
    if (data.containsKey('company')) {
      return _buildSingleCareerCard(data);
    }

    // Birden fazla career varsa (careers array)
    if (data.containsKey('careers') && data['careers'] is List) {
      List<dynamic> careers = data['careers'] as List;
      return _buildMultipleCareerCards(careers);
    }

    return _buildEmptyState();
  }

  Widget _buildSingleCareerCard(Map<String, dynamic> career) {
    return Column(
      children: [_buildCareerCard(career, 0, 1), const SizedBox(height: 20)],
    );
  }

  Widget _buildMultipleCareerCards(List<dynamic> careers) {
    return Column(
      //reverse
      children: [
        // Timeline başlığı
        Row(
          children: [
            Icon(Icons.timeline, color: Colors.blue.withOpacity(0.8), size: 24),
            const SizedBox(width: 10),
            Text(
              'CAREER TIMELINE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.withOpacity(0.9),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Career kartları
        ...careers.reversed.toList().asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> career = entry.value;
          return Column(
            children: [
              _buildCareerCard(career, index, careers.length),
              if (index < careers.length - 1) const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCareerCard(Map<String, dynamic> career, int index, int total) {
    String company = career['company']?.toString() ?? 'Unknown Company';
    String position = career['position']?.toString() ?? 'Unknown Position';
    String department = career['department']?.toString() ?? '';
    String location = career['location']?.toString() ?? '';
    String employmentType = career['employmentType']?.toString() ?? '';
    bool currentJob = career['currentJob'] ?? false;

    String startDate = _formatDate(career['startDate']);
    String endDate = currentJob ? 'Present' : _formatDate(career['endDate']);

    String? duration = _calculateDuration(
      career['startDate'],
      career['endDate'],
      currentJob,
    );

    List<String> responsibilities = [];
    if (career['responsibilities'] != null &&
        career['responsibilities'] is List) {
      responsibilities =
          (career['responsibilities'] as List)
              .map((r) => r.toString())
              .toList();
    }

    List<String> achievements = [];
    if (career['achievements'] != null && career['achievements'] is List) {
      achievements =
          (career['achievements'] as List).map((a) => a.toString()).toList();
    }

    List<String> technologies = [];
    if (career['technologies'] != null && career['technologies'] is List) {
      technologies =
          (career['technologies'] as List).map((t) => t.toString()).toList();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              currentJob
                  ? Colors.green.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
        ),
        boxShadow:
            currentJob
                ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst kısım - Company ve Position
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot (sadece birden fazla career varsa)
              if (total > 1) ...[
                Container(
                  margin: const EdgeInsets.only(top: 4, right: 15),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: currentJob ? Colors.green : Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      if (index < total - 1)
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.white.withOpacity(0.2),
                        ),
                    ],
                  ),
                ),
              ],

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company name
                    Text(
                      company,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Position
                    Text(
                      position,
                      style: TextStyle(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Department
                    if (department.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        department,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Current job badge
              if (currentJob)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    'CURRENT',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 15),

          // Tarih ve lokasyon bilgileri
          _buildInfoRow([
            if (startDate.isNotEmpty || endDate.isNotEmpty)
              _buildInfoChip('📅 $startDate - $endDate', Colors.orange),
            if (duration != null) _buildInfoChip('⏱️ $duration', Colors.amber),
            if (location.isNotEmpty)
              _buildInfoChip('📍 $location', Colors.purple),
            if (employmentType.isNotEmpty)
              _buildInfoChip(
                '💼 ${_formatEmploymentType(employmentType)}',
                Colors.teal,
              ),
          ]),

          // Responsibilities
          if (responsibilities.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('RESPONSIBILITIES'),
            const SizedBox(height: 10),
            ...responsibilities.map((resp) => _buildBulletPoint(resp)),
          ],

          // Achievements
          if (achievements.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('ACHIEVEMENTS'),
            const SizedBox(height: 10),
            ...achievements.map(
              (achievement) => _buildAchievementPoint(achievement),
            ),
          ],

          // Technologies
          if (technologies.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('TECHNOLOGIES'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  technologies.map((tech) => _buildTechChip(tech)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(List<Widget> chips) {
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.7),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 2, right: 10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Icon(Icons.star, color: Colors.green, size: 10),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        tech,
        style: TextStyle(
          fontSize: 11,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.work_outline,
            color: Colors.white.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No Career Information',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Career details will be displayed here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return '';

    try {
      DateTime date;
      if (dateValue is DateTime) {
        date = dateValue;
      } else if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else {
        return dateValue.toString();
      }

      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateValue.toString();
    }
  }

  String _formatEmploymentType(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return 'Full-time';
      case 'part-time':
        return 'Part-time';
      case 'contract':
        return 'Contract';
      case 'internship':
        return 'Internship';
      case 'freelance':
        return 'Freelance';
      case 'volunteer':
        return 'Volunteer';
      default:
        return type;
    }
  }

  String? _calculateDuration(
    dynamic startDateValue,
    dynamic endDateValue,
    bool isCurrentJob,
  ) {
    if (startDateValue == null) return null;

    try {
      DateTime startDate;
      if (startDateValue is Timestamp) {
        startDate = startDateValue.toDate();
      } else if (startDateValue is String) {
        startDate = DateTime.parse(startDateValue);
      } else {
        return null;
      }

      DateTime endDate;
      if (isCurrentJob) {
        endDate = DateTime.now();
      } else if (endDateValue != null) {
        if (endDateValue is Timestamp) {
          endDate = endDateValue.toDate();
        } else if (endDateValue is String) {
          endDate = DateTime.parse(endDateValue);
        } else {
          return null;
        }
      } else {
        return null;
      }

      Duration difference = endDate.difference(startDate);
      int totalDays = difference.inDays;

      if (totalDays < 30) {
        return '$totalDays days';
      }

      int years = (totalDays / 365).floor();
      int remainingDays = totalDays % 365;
      int months = (remainingDays / 30).floor();

      List<String> parts = [];
      if (years > 0) {
        parts.add('$years year${years > 1 ? 's' : ''}');
      }
      if (months > 0) {
        parts.add('$months month${months > 1 ? 's' : ''}');
      }

      if (parts.isEmpty && totalDays > 0) {
        return '$totalDays days';
      } else if (parts.isEmpty) {
        return null;
      }
      return parts.join(' ');
    } catch (e) {
      return null;
    }
  }
}
