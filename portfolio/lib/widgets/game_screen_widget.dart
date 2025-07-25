import 'package:flutter/material.dart';
import 'snake_game_widget.dart';
import 'tetris_game_widget.dart';

class GameScreenWidget extends StatelessWidget {
  final String gameType;
  final VoidCallback onBackPressed;

  const GameScreenWidget({
    super.key,
    required this.gameType,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (gameType) {
      case 'game1':
        return SnakeGameWidget(onBackPressed: onBackPressed);
      case 'game2':
        return TetrisGameWidget(onBackPressed: onBackPressed);
      default:
        return GameNotFoundWidget(onBackPressed: onBackPressed);
    }
  }
}

class GameNotFoundWidget extends StatelessWidget {
  final VoidCallback onBackPressed;

  const GameNotFoundWidget({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.games, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Oyun Bulunamadı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onBackPressed,
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
