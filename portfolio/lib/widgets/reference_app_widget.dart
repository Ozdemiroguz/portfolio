import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/app.dart';

class ReferenceAppWidget extends StatelessWidget {
  final App openApp;

  const ReferenceAppWidget({super.key, required this.openApp});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Üst boşluk - geri butonu için
          const SizedBox(height: 100),

          // İçerik container
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // References
                  _buildReferences(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple.withOpacity(0.3)),
          ),
          child: const Icon(Icons.recommend, size: 50, color: Colors.purple),
        ),
        const SizedBox(height: 15),
        Text(
          openApp.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          openApp.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReferences() {
    final data = openApp.data;

    if (data.isEmpty || !data.containsKey('references')) {
      return _buildEmptyState();
    }

    final references = data['references'];
    if (references is! List || references.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFERENCES',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),

        ...references
            .map<Widget>((reference) => _buildReferenceCard(reference))
            .toList(),
      ],
    );
  }

  Widget _buildReferenceCard(dynamic reference) {
    if (reference is! Map<String, dynamic>) return const SizedBox.shrink();

    final name = reference['name']?.toString() ?? 'Unknown';
    final position = reference['position']?.toString() ?? '';
    final company = reference['company']?.toString() ?? '';
    final email = reference['email']?.toString() ?? '';
    final phone = reference['phone']?.toString() ?? '';
    final linkedin = reference['linkedin']?.toString() ?? '';
    final relationship = reference['relationship']?.toString() ?? '';
    final recommendation = reference['recommendation']?.toString() ?? '';
    final canContact = reference['canContact'] == true;
    final workTogether = reference['workTogether']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and relationship
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (position.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        position,
                        style: TextStyle(
                          color: Colors.purple.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (company.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        company,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (relationship.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getRelationshipColor(relationship).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _getRelationshipColor(
                        relationship,
                      ).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    _formatRelationship(relationship),
                    style: TextStyle(
                      color: _getRelationshipColor(relationship),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          // Contact information
          if (email.isNotEmpty || phone.isNotEmpty || linkedin.isNotEmpty) ...[
            const SizedBox(height: 15),
            _buildContactInfo(email, phone, linkedin, canContact),
          ],

          // Work together date
          if (workTogether.isNotEmpty) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Worked together: ${_formatDate(workTogether)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          // Recommendation
          if (recommendation.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 18,
                        color: Colors.purple.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RECOMMENDATION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recommendation,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfo(
    String email,
    String phone,
    String linkedin,
    bool canContact,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              canContact ? Icons.contact_phone : Icons.contact_phone_outlined,
              size: 16,
              color: canContact ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              canContact ? 'Available for contact' : 'Contact on request',
              style: TextStyle(
                color: canContact ? Colors.green : Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (email.isNotEmpty)
              _buildContactButton(Icons.email, 'Email', email),
            if (phone.isNotEmpty)
              _buildContactButton(Icons.phone, 'Phone', phone),
            if (linkedin.isNotEmpty)
              _buildContactButton(Icons.business, 'LinkedIn', linkedin),
          ],
        ),
      ],
    );
  }

  Widget _buildContactButton(IconData icon, String label, String value) {
    return Builder(
      builder:
          (context) => InkWell(
            onTap: () => _copyToClipboard(context, value),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: Colors.white.withOpacity(0.7)),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No references available yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Reference information will be added soon.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getRelationshipColor(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'manager':
        return Colors.blue;
      case 'colleague':
        return Colors.green;
      case 'client':
        return Colors.orange;
      case 'mentor':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatRelationship(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'manager':
        return 'MANAGER';
      case 'colleague':
        return 'COLLEAGUE';
      case 'client':
        return 'CLIENT';
      case 'mentor':
        return 'MENTOR';
      default:
        return relationship.toUpperCase();
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
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
      return dateString;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        backgroundColor: Colors.purple.withOpacity(0.8),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
