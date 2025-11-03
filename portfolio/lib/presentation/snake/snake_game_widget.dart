import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'dart:math';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({super.key});

  @override
  State<SnakeGameWidget> createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  static const int boardSize = 20;
  List<int> snake = [45, 65, 85, 105, 125];
  int food = Random().nextInt(400);
  String direction = 'down';
  bool gameStarted = false;
  bool gameOver = false;
  int score = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    snake = [45, 65, 85, 105, 125];
    food = Random().nextInt(400);
    direction = 'down';
    gameStarted = true;
    gameOver = false;
    score = 0;

    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateGame();
    });

    setState(() {});
  }

  void updateGame() {
    setState(() {
      // Yılanı hareket ettir
      switch (direction) {
        case 'up':
          if (snake.last < boardSize) {
            gameOver = true;
          } else {
            snake.add(snake.last - boardSize);
          }
          break;
        case 'down':
          if (snake.last + boardSize >= 400) {
            gameOver = true;
          } else {
            snake.add(snake.last + boardSize);
          }
          break;
        case 'left':
          if (snake.last % boardSize == 0) {
            gameOver = true;
          } else {
            snake.add(snake.last - 1);
          }
          break;
        case 'right':
          if ((snake.last + 1) % boardSize == 0) {
            gameOver = true;
          } else {
            snake.add(snake.last + 1);
          }
          break;
      }

      // Kendine çarpma kontrolü
      if (snake.length > 1) {
        for (int i = 0; i < snake.length - 1; i++) {
          if (snake[i] == snake.last) {
            gameOver = true;
          }
        }
      }

      // Yemek yeme kontrolü
      if (snake.last == food) {
        score += 10;
        generateFood();
      } else {
        snake.removeAt(0);
      }

      // Oyun bitti
      if (gameOver) {
        timer?.cancel();
      }
    });
  }

  void generateFood() {
    food = Random().nextInt(400);
    while (snake.contains(food)) {
      food = Random().nextInt(400);
    }
  }

  void resetGame() {
    timer?.cancel();
    setState(() {
      snake = [45, 65, 85, 105, 125];
      food = Random().nextInt(400);
      direction = 'down';
      gameStarted = false;
      gameOver = false;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (gameStarted && !gameOver && event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
            case LogicalKeyboardKey.keyA:
              setState(() => direction = 'left');
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowRight:
            case LogicalKeyboardKey.keyD:
              setState(() => direction = 'right');
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowUp:
            case LogicalKeyboardKey.keyW:
              setState(() => direction = 'up');
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowDown:
            case LogicalKeyboardKey.keyS:
              setState(() => direction = 'down');
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f4c3a), Color(0xFF1a5f4a), Color(0xFF2d7a5a)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SnakeHeaderWidget(score: score),
              SnakeGameBoardWidget(
                snake: snake,
                food: food,
                boardSize: boardSize,
              ),
              SnakeControlsWidget(
                gameStarted: gameStarted,
                gameOver: gameOver,
                score: score,
                direction: direction,
                onStartGame: startGame,
                onResetGame: resetGame,
                onDirectionChange: (newDirection) {
                  setState(() => direction = newDirection);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SnakeHeaderWidget extends StatelessWidget {
  final int score;

  const SnakeHeaderWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 80, right: 32, top: 32, bottom: 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('snake.title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tr('snake.keyboard'),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            tr('snake.score', namedArgs: {'score': score.toString()}),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SnakeGameBoardWidget extends StatelessWidget {
  final List<int> snake;
  final int food;
  final int boardSize;

  const SnakeGameBoardWidget({
    super.key,
    required this.snake,
    required this.food,
    required this.boardSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 400,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: boardSize,
            ),
            itemBuilder: (context, index) {
              if (snake.contains(index)) {
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              } else if (index == food) {
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class SnakeControlsWidget extends StatelessWidget {
  final bool gameStarted;
  final bool gameOver;
  final int score;
  final String direction;
  final VoidCallback onStartGame;
  final VoidCallback onResetGame;
  final Function(String) onDirectionChange;

  const SnakeControlsWidget({
    super.key,
    required this.gameStarted,
    required this.gameOver,
    required this.score,
    required this.direction,
    required this.onStartGame,
    required this.onResetGame,
    required this.onDirectionChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Start Button
        if (!gameStarted && !gameOver)
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: onStartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                tr('snake.startGame'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Game Over
        if (gameOver)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  tr('snake.gameOver'),
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  tr(
                    'snake.finalScore',
                    namedArgs: {'score': score.toString()},
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: onResetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    tr('snake.playAgain'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Direction Controls
        if (gameStarted && !gameOver)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Up
                IconButton(
                  onPressed: () => onDirectionChange('up'),
                  icon: Icon(
                    Icons.keyboard_arrow_up,
                    color: direction == 'up' ? Colors.yellow : Colors.white,
                    size: 40,
                  ),
                ),
                // Left, Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => onDirectionChange('left'),
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color:
                            direction == 'left' ? Colors.yellow : Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 60),
                    IconButton(
                      onPressed: () => onDirectionChange('right'),
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color:
                            direction == 'right' ? Colors.yellow : Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                // Down
                IconButton(
                  onPressed: () => onDirectionChange('down'),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: direction == 'down' ? Colors.yellow : Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
