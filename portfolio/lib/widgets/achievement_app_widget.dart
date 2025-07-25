import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app.dart';

class AchievementAppWidget extends StatelessWidget {
  final App openApp;

  const AchievementAppWidget({super.key, required this.openApp});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Üst boşluk - geri butonu için
          const SizedBox(height: 100),

          // Achievement içeriği
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildAchievementContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementContent() {
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

        // Achievement Content
        _buildAchievementList(data),
      ],
    );
  }

  Widget _buildAchievementList(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return _buildEmptyState();
    }

    // Tek achievement objesi varsa (Firebase structure'a göre)
    if (data.containsKey('category') || data.containsKey('issuer')) {
      return _buildSingleAchievementCard(data);
    }

    // Birden fazla achievement varsa (achievements array)
    if (data.containsKey('achievements') && data['achievements'] is List) {
      List<dynamic> achievements = data['achievements'] as List;
      return _buildMultipleAchievementCards(achievements);
    }

    return _buildEmptyState();
  }

  Widget _buildSingleAchievementCard(Map<String, dynamic> achievement) {
    return Column(
      children: [
        _buildAchievementCard(achievement),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMultipleAchievementCards(List<dynamic> achievements) {
    return Column(
      children: [
        // Achievement başlığı
        Row(
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.amber.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'ACHIEVEMENTS & CERTIFICATIONS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber.withOpacity(0.9),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Achievement kartları
        ...achievements.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> achievement = entry.value;
          return Column(
            children: [
              _buildAchievementCard(achievement),
              if (index < achievements.length - 1) const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    String category = achievement['category']?.toString() ?? 'achievement';
    String issuer = achievement['issuer']?.toString() ?? 'Unknown Issuer';
    String level = achievement['level']?.toString() ?? '';
    String score = achievement['score']?.toString() ?? '';
    String grade = achievement['grade']?.toString() ?? '';
    String credentialId = achievement['credentialId']?.toString() ?? '';
    String credentialUrl = achievement['credentialUrl']?.toString() ?? '';
    String verificationUrl = achievement['verificationUrl']?.toString() ?? '';
    String title = achievement['title']?.toString() ?? 'Unknown Achievement';

    String issueDate = _formatDate(achievement['issueDate']);
    String expiryDate = _formatDate(achievement['expiryDate']);
    bool hasExpiry = expiryDate.isNotEmpty;
    bool isExpired = hasExpiry && _isExpired(achievement['expiryDate']);

    List<String> skills = [];
    if (achievement['skills'] != null && achievement['skills'] is List) {
      skills =
          (achievement['skills'] as List).map((s) => s.toString()).toList();
    }

    CategoryInfo categoryInfo = _getCategoryInfo(category);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              isExpired
                  ? Colors.red.withOpacity(0.3)
                  : categoryInfo.color.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: categoryInfo.color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst kısım - Category badge ve issuer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: categoryInfo.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: categoryInfo.color.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  categoryInfo.icon,
                  color: categoryInfo.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryInfo.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: categoryInfo.color.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        categoryInfo.name,
                        style: TextStyle(
                          fontSize: 10,
                          color: categoryInfo.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Achievement title (app title)
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Issuer
                    Text(
                      'by $issuer',
                      style: TextStyle(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Expired badge
              if (isExpired)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    'EXPIRED',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 15),

          // Tarih ve seviye bilgileri
          _buildInfoRow([
            if (issueDate.isNotEmpty)
              _buildInfoChip('📅 Issued: $issueDate', Colors.green),
            if (hasExpiry)
              _buildInfoChip(
                '⏰ Expires: $expiryDate',
                isExpired ? Colors.red : Colors.orange,
              ),
            if (level.isNotEmpty)
              _buildInfoChip('📊 Level: ${_formatLevel(level)}', Colors.purple),
          ]),

          // Score ve Grade
          if (score.isNotEmpty || grade.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow([
              if (score.isNotEmpty)
                _buildInfoChip('🎯 Score: $score', Colors.teal),
              if (grade.isNotEmpty)
                _buildInfoChip('🏆 Grade: $grade', Colors.amber),
            ]),
          ],

          // Skills
          if (skills.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionTitle('SKILLS COVERED'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: skills.map((skill) => _buildSkillChip(skill)).toList(),
            ),
          ],

          // Credential Information
          if (credentialId.isNotEmpty ||
              credentialUrl.isNotEmpty ||
              verificationUrl.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildCredentialSection(
              credentialId,
              credentialUrl,
              verificationUrl,
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

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontSize: 11,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCredentialSection(
    String credentialId,
    String credentialUrl,
    String verificationUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('CREDENTIAL INFORMATION'),
          const SizedBox(height: 12),

          // Credential ID
          if (credentialId.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.badge,
                  color: Colors.blue.withOpacity(0.7),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'ID: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Expanded(
                  child: Text(
                    credentialId,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyToClipboard(credentialId),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.copy,
                      color: Colors.white.withOpacity(0.6),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Action buttons
          Row(
            children: [
              // View Credential
              if (credentialUrl.isNotEmpty) ...[
                Expanded(
                  child: _buildActionButton(
                    'View Credential',
                    Icons.open_in_new,
                    Colors.blue,
                    () => _openUrl(credentialUrl),
                  ),
                ),
                if (verificationUrl.isNotEmpty) const SizedBox(width: 8),
              ],

              // Verify
              if (verificationUrl.isNotEmpty)
                Expanded(
                  child: _buildActionButton(
                    'Verify',
                    Icons.verified,
                    Colors.green,
                    () => _openUrl(verificationUrl),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
            Icons.emoji_events_outlined,
            color: Colors.white.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No Achievements',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Achievements and certifications will be displayed here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  CategoryInfo _getCategoryInfo(String category) {
    switch (category.toLowerCase()) {
      case 'certificate':
        return CategoryInfo(
          name: 'CERTIFICATE',
          icon: Icons.school,
          color: Colors.blue,
        );
      case 'award':
        return CategoryInfo(
          name: 'AWARD',
          icon: Icons.emoji_events,
          color: Colors.amber,
        );
      case 'recognition':
        return CategoryInfo(
          name: 'RECOGNITION',
          icon: Icons.star,
          color: Colors.purple,
        );
      case 'competition':
        return CategoryInfo(
          name: 'COMPETITION',
          icon: Icons.sports_esports,
          color: Colors.orange,
        );
      default:
        return CategoryInfo(
          name: category.toUpperCase(),
          icon: Icons.emoji_events,
          color: Colors.green,
        );
    }
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

  String _formatLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      case 'expert':
        return 'Expert';
      default:
        return level;
    }
  }

  bool _isExpired(dynamic expiryDate) {
    if (expiryDate == null) return false;

    try {
      DateTime expiry;
      if (expiryDate is DateTime) {
        expiry = expiryDate;
      } else if (expiryDate is String) {
        expiry = DateTime.parse(expiryDate);
      } else {
        return false;
      }

      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return false;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error
    }
  }
}

class CategoryInfo {
  final String name;
  final IconData icon;
  final Color color;

  CategoryInfo({required this.name, required this.icon, required this.color});
}
