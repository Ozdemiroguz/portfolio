import 'package:flutter/material.dart';
import '../../domain/entities/app_entity.dart';
import 'tetris_game_widget.dart';

class TetrisScreen extends StatelessWidget {
  final AppEntity app;

  const TetrisScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return const TetrisGameWidget();
  }
}
