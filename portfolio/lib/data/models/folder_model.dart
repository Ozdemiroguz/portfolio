import 'package:equatable/equatable.dart';
import '../../core/utils/date_helpers.dart';

/// Folder data model
/// Represents a folder that contains multiple apps
class FolderModel extends Equatable {
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

  const FolderModel({
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

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Folder',
      description: json['description'] ?? 'No description available',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#2196F3',
      appIds: List<String>.from(json['appIds'] ?? []),
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateHelpers.parseDateTime(json['createdAt']),
      updatedAt: DateHelpers.parseDateTime(json['updatedAt']),
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        color,
        appIds,
        order,
        isActive,
        createdAt,
        updatedAt,
      ];
}
