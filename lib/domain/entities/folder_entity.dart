import 'package:equatable/equatable.dart';

/// Folder domain entity
class FolderEntity extends Equatable {
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

  const FolderEntity({
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
