import 'package:flutter/material.dart';
import '../models/app.dart';

class AboutAppWidget extends StatelessWidget {
  final App openApp;

  const AboutAppWidget({super.key, required this.openApp});

  @override
  Widget build(BuildContext context) {
    // Resim listesini hazırla
    List<String> images = [];

    // Önce data.images'tan al (about spesifik resimler)
    if (openApp.data.containsKey('images') == true) {
      images = List<String>.from(openApp.data['images'] ?? []);
    }
    // Sonra genel images'tan al
    else if (openApp.images.isNotEmpty) {
      images = openApp.images;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Üst boşluk - geri butonu için
          const SizedBox(height: 100),

          // Resim - glass container ile çerçeveli
          if (images.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image.network(
                    images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          // About içeriği
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildAboutContent(),
          ),
        ],
      ),
    );
  }

  // Boş değerleri kontrol eden helper fonksiyon
  bool _isValueNotEmpty(dynamic value) {
    if (value == null) return false;

    if (value is String) {
      String trimmed = value.trim();
      if (trimmed.isEmpty) return false;
      // Sadece boşluk, virgül, alt tire veya nokta içeriyorsa boş say
      if (RegExp(r'^[\s,._-]*$').hasMatch(trimmed)) return false;
      return true;
    }

    if (value is List) {
      // Liste boşsa veya tüm elemanları boşsa
      List<String> nonEmptyItems =
          value
              .map((e) => e.toString().trim())
              .where(
                (item) =>
                    item.isNotEmpty && !RegExp(r'^[\s,._-]*$').hasMatch(item),
              )
              .toList();
      return nonEmptyItems.isNotEmpty;
    }

    if (value is Map) {
      // Map boşsa veya tüm değerleri boşsa
      return value.values.any((v) => _isValueNotEmpty(v));
    }

    // Diğer türler için string'e çevirip kontrol et
    return value.toString().trim().isNotEmpty;
  }

  Widget _buildAboutContent() {
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

        const SizedBox(height: 15),

        // Data sections - about hariç, vision düz paragraf, boş kısımları gizle, contact bilgilerini gizle
        if (data.isNotEmpty) ...[
          ...data.entries
              .where(
                (entry) =>
                    _isValueNotEmpty(entry.value) && // Boş değerleri filtrele
                    entry.key.toLowerCase() !=
                        'about' && // About kısmını kaldır
                    entry.key.toLowerCase() != 'email' && // Email'i gizle
                    entry.key.toLowerCase() != 'phone' && // Telefonu gizle
                    entry.key.toLowerCase() != 'address' && // Adresi gizle
                    entry.key.toLowerCase() != 'links', // Linkleri gizle
              )
              .map((entry) => _buildDataCard(entry.key, entry.value)),
        ],
      ],
    );
  }

  Widget _buildDataCard(String key, dynamic value) {
    // Değer boşsa widget'ı gösterme
    if (!_isValueNotEmpty(value)) return const SizedBox.shrink();

    // Key'e göre icon ve renk belirle
    IconData icon = _getIconForKey(key);
    Color iconColor = _getColorForKey(key);

    // Hobbies ve personality için özel widget (vision hariç)
    if (key.toLowerCase() == 'hobbies' || key.toLowerCase() == 'personality') {
      return _buildSpecialItemsCard(key, value, icon, iconColor);
    }

    // Vision için düz paragraf - parçalamadan
    if (key.toLowerCase() == 'vision') {
      return _buildVisionCard(key, value, icon, iconColor);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: iconColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Key başlığı
                Text(
                  _formatKeyTitle(key),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: iconColor.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Value içeriği
                _buildValueContent(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueContent(dynamic value) {
    if (value is List) {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: value.map((item) => _buildChip(item.toString())).toList(),
      );
    } else if (value is String &&
        (value.contains(',') || value.contains('\n'))) {
      // Virgül veya satır ile ayrılmış değerler
      List<String> items =
          value.contains(',')
              ? value.split(',').map((e) => e.trim()).toList()
              : value.split('\n').map((e) => e.trim()).toList();

      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children:
            items
                .where((item) => item.isNotEmpty)
                .map((item) => _buildChip(item))
                .toList(),
      );
    } else {
      return Text(
        value.toString(),
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.9),
          height: 1.5,
        ),
      );
    }
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'name':
      case 'fullname':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'location':
      case 'address':
        return Icons.location_on;
      case 'skills':
        return Icons.code;
      case 'languages':
        return Icons.language;
      case 'hobbies':
        return Icons.favorite;
      case 'education':
        return Icons.school;
      case 'experience':
      case 'work':
        return Icons.work;
      case 'personality':
        return Icons.psychology;
      case 'social':
      case 'links':
        return Icons.link;
      case 'age':
        return Icons.cake;
      case 'bio':
        return Icons.info;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForKey(String key) {
    switch (key.toLowerCase()) {
      case 'name':
      case 'fullname':
        return Colors.blue;
      case 'email':
        return Colors.red;
      case 'phone':
        return Colors.green;
      case 'location':
      case 'address':
        return Colors.orange;
      case 'skills':
        return Colors.purple;
      case 'languages':
        return Colors.teal;
      case 'hobbies':
        return Colors.pink;
      case 'education':
        return Colors.indigo;
      case 'experience':
      case 'work':
        return Colors.brown;
      case 'personality':
        return Colors.cyan;
      case 'social':
      case 'links':
        return Colors.lime;
      case 'age':
        return Colors.amber;
      case 'bio':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  String _formatKeyTitle(String key) {
    // İlk harfi büyük yap ve kelimeler arası boşluk ekle
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ')
        .trim();
  }

  Widget _buildVisionCard(
    String key,
    dynamic value,
    IconData icon,
    Color iconColor,
  ) {
    // Eğer vision boşsa widget'ı gösterme
    if (!_isValueNotEmpty(value)) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: iconColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Key başlığı
                Text(
                  _formatKeyTitle(key),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: iconColor.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Vision içeriği - düz paragraf olarak
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialItemsCard(
    String key,
    dynamic value,
    IconData mainIcon,
    Color iconColor,
  ) {
    // Value'yu liste haline getir
    List<String> items = [];

    if (value is List) {
      items = value.map((e) => e.toString()).toList();
    } else if (value is String) {
      // Underscore ile ayrılmış değerleri kontrol et
      if (value.contains('_')) {
        items = value.split('_').map((e) => e.trim()).toList();
      } else if (value.contains(',')) {
        items = value.split(',').map((e) => e.trim()).toList();
      } else if (value.contains('\n')) {
        items = value.split('\n').map((e) => e.trim()).toList();
      } else {
        items = [value];
      }
    } else {
      items = [value.toString()];
    }

    // Boş itemları daha kapsamlı filtrele
    items =
        items
            .where(
              (item) =>
                  item.trim().isNotEmpty &&
                  !RegExp(r'^[\s,._-]*$').hasMatch(item.trim()),
            )
            .toList();

    // Eğer hiç item kalmadıysa widget'ı gösterme
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: iconColor.withOpacity(0.3)),
                ),
                child: Icon(mainIcon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                _formatKeyTitle(key),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: iconColor.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items - her biri ayrı widget
          ...items.map((item) => _buildIndividualItem(item, key)),
        ],
      ),
    );
  }

  Widget _buildIndividualItem(String item, String category) {
    IconData itemIcon = _getIconForItem(item, category);
    Color itemColor = _getColorForKey(category);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: itemColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(itemIcon, color: itemColor.withOpacity(0.8), size: 14),
          ),
          const SizedBox(width: 10),

          // Item text
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForItem(String item, String category) {
    String lowerItem = item.toLowerCase();
    String lowerCategory = category.toLowerCase();

    if (lowerCategory == 'hobbies') {
      // Hobi ikonları
      if (lowerItem.contains('music') || lowerItem.contains('müzik')) {
        return Icons.music_note;
      }
      if (lowerItem.contains('read') ||
          lowerItem.contains('book') ||
          lowerItem.contains('kitap')) {
        return Icons.book;
      }
      if (lowerItem.contains('game') || lowerItem.contains('oyun')) {
        return Icons.games;
      }
      if (lowerItem.contains('sport') ||
          lowerItem.contains('spor') ||
          lowerItem.contains('football') ||
          lowerItem.contains('futbol')) {
        return Icons.sports_soccer;
      }
      if (lowerItem.contains('travel') || lowerItem.contains('seyahat')) {
        return Icons.flight;
      }
      if (lowerItem.contains('photo') || lowerItem.contains('fotoğraf')) {
        return Icons.camera_alt;
      }
      if (lowerItem.contains('cook') || lowerItem.contains('yemek')) {
        return Icons.restaurant;
      }
      if (lowerItem.contains('movie') || lowerItem.contains('film')) {
        return Icons.movie;
      }
      if (lowerItem.contains('art') || lowerItem.contains('sanat')) {
        return Icons.palette;
      }
      if (lowerItem.contains('gym') || lowerItem.contains('fitness')) {
        return Icons.fitness_center;
      }
      if (lowerItem.contains('tennis')) {
        return Icons.sports_tennis;
      }
      if (lowerItem.contains('walk') || lowerItem.contains('yürüyüş')) {
        return Icons.directions_walk;
      }
      if (lowerItem.contains('tech') || lowerItem.contains('exploring')) {
        return Icons.computer;
      }
      if (lowerItem.contains('project') || lowerItem.contains('building')) {
        return Icons.build;
      }
      if (lowerItem.contains('chess') || lowerItem.contains('satranç')) {
        return Icons.casino;
      }
      if (lowerItem.contains('quality') || lowerItem.contains('watching')) {
        return Icons.movie_filter;
      }
      if (lowerItem.contains('series') || lowerItem.contains('animation')) {
        return Icons.tv;
      }
      if (lowerItem.contains('indie')) {
        return Icons.lightbulb;
      }
      if (lowerItem.contains('side')) {
        return Icons.extension;
      }
      if (lowerItem.contains('reading') || lowerItem.contains('product')) {
        return Icons.psychology;
      }
      if (lowerItem.contains('thinking')) {
        return Icons.lightbulb_outline;
      }
      return Icons.favorite_outline;
    } else if (lowerCategory == 'personality') {
      // Kişilik ikonları
      if (lowerItem.contains('creative') || lowerItem.contains('yaratıcı')) {
        return Icons.create;
      }
      if (lowerItem.contains('leader') || lowerItem.contains('lider')) {
        return Icons.groups;
      }
      if (lowerItem.contains('friendly') || lowerItem.contains('arkadaş')) {
        return Icons.sentiment_very_satisfied;
      }
      if (lowerItem.contains('patient') || lowerItem.contains('sabır')) {
        return Icons.self_improvement;
      }
      if (lowerItem.contains('curious') ||
          lowerItem.contains('meraklı') ||
          lowerItem.contains('calm')) {
        return Icons.search;
      }
      if (lowerItem.contains('hardworking') || lowerItem.contains('çalışkan')) {
        return Icons.work_outline;
      }
      if (lowerItem.contains('detail') || lowerItem.contains('structured')) {
        return Icons.format_list_bulleted;
      }
      if (lowerItem.contains('open') || lowerItem.contains('criticism')) {
        return Icons.feedback;
      }
      if (lowerItem.contains('obsessed') || lowerItem.contains('improvement')) {
        return Icons.trending_up;
      }
      if (lowerItem.contains('autonomy') ||
          lowerItem.contains('collaborative')) {
        return Icons.group_work;
      }
      if (lowerItem.contains('fast') || lowerItem.contains('learner')) {
        return Icons.school;
      }
      if (lowerItem.contains('never') || lowerItem.contains('settles')) {
        return Icons.all_inclusive;
      }
      return Icons.psychology;
    }

    return Icons.circle;
  }
}
