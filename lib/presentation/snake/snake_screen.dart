import 'package:flutter/material.dart';
import '../../domain/entities/app_entity.dart';
import 'snake_game_widget.dart';

class SnakeScreen extends StatelessWidget {
  final AppEntity app;

  const SnakeScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return const SnakeGameWidget();
  }
}
