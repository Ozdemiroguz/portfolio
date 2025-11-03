// Helper method to parse DateTime
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is String) return DateTime.parse(value);
  if (value is DateTime) return value;
  return DateTime.now();
}

class Folder {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final List<String> appIds;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Folder({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.appIds,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Klasör',
      description: json['description'] ?? 'Açıklama bulunamadı',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#2196F3',
      appIds: List<String>.from(json['appIds'] ?? []),
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
      'appIds': appIds,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
