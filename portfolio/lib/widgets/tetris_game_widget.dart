import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class TetrisGameWidget extends StatefulWidget {
  final VoidCallback onBackPressed;

  const TetrisGameWidget({super.key, required this.onBackPressed});

  @override
  State<TetrisGameWidget> createState() => _TetrisGameWidgetState();
}

class _TetrisGameWidgetState extends State<TetrisGameWidget> {
  static const int boardWidth = 10;
  static const int boardHeight = 16;
  List<List<int>> board = [];
  List<List<int>> currentPiece = [];
  int currentX = 0;
  int currentY = 0;
  bool gameStarted = false;
  bool gameOver = false;
  int score = 0;
  int level = 1;
  Timer? timer;

  // Tetris parçaları
  List<List<List<int>>> pieces = [
    // I parçası
    [
      [1, 1, 1, 1],
    ],
    // O parçası
    [
      [1, 1],
      [1, 1],
    ],
    // T parçası
    [
      [0, 1, 0],
      [1, 1, 1],
    ],
    // S parçası
    [
      [0, 1, 1],
      [1, 1, 0],
    ],
    // Z parçası
    [
      [1, 1, 0],
      [0, 1, 1],
    ],
    // J parçası
    [
      [1, 0, 0],
      [1, 1, 1],
    ],
    // L parçası
    [
      [0, 0, 1],
      [1, 1, 1],
    ],
  ];

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initializeBoard() {
    board = List.generate(
      boardHeight,
      (index) => List.generate(boardWidth, (index) => 0),
    );
  }

  void startGame() {
    initializeBoard();
    gameStarted = true;
    gameOver = false;
    score = 0;
    level = 1;
    spawnNewPiece();
    startTimer();
    setState(() {});
  }

  void startTimer() {
    timer?.cancel();
    int speed = (1000 - (level * 100)).clamp(100, 1000);
    timer = Timer.periodic(Duration(milliseconds: speed), (timer) {
      if (!gameOver) {
        moveDown();
      }
    });
  }

  void spawnNewPiece() {
    currentPiece = List.from(pieces[Random().nextInt(pieces.length)]);
    currentX = (boardWidth ~/ 2) - (currentPiece[0].length ~/ 2);
    currentY = 0;

    if (checkCollision()) {
      gameOver = true;
      timer?.cancel();
    }
  }

  bool checkCollision() {
    for (int i = 0; i < currentPiece.length; i++) {
      for (int j = 0; j < currentPiece[i].length; j++) {
        if (currentPiece[i][j] == 1) {
          int x = currentX + j;
          int y = currentY + i;

          if (x < 0 || x >= boardWidth || y >= boardHeight) {
            return true;
          }
          if (y >= 0 && board[y][x] == 1) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void moveLeft() {
    currentX--;
    if (checkCollision()) {
      currentX++;
    }
    setState(() {});
  }

  void moveRight() {
    currentX++;
    if (checkCollision()) {
      currentX--;
    }
    setState(() {});
  }

  void moveDown() {
    currentY++;
    if (checkCollision()) {
      currentY--;
      placePiece();
      clearLines();
      spawnNewPiece();
    }
    setState(() {});
  }

  void rotatePiece() {
    List<List<int>> rotated = [];
    int rows = currentPiece.length;
    int cols = currentPiece[0].length;

    for (int j = 0; j < cols; j++) {
      List<int> newRow = [];
      for (int i = rows - 1; i >= 0; i--) {
        newRow.add(currentPiece[i][j]);
      }
      rotated.add(newRow);
    }

    List<List<int>> oldPiece = currentPiece;
    currentPiece = rotated;

    if (checkCollision()) {
      currentPiece = oldPiece;
    }
    setState(() {});
  }

  void placePiece() {
    for (int i = 0; i < currentPiece.length; i++) {
      for (int j = 0; j < currentPiece[i].length; j++) {
        if (currentPiece[i][j] == 1) {
          int x = currentX + j;
          int y = currentY + i;
          if (y >= 0 && y < boardHeight && x >= 0 && x < boardWidth) {
            board[y][x] = 1;
          }
        }
      }
    }
  }

  void clearLines() {
    int linesCleared = 0;
    for (int i = boardHeight - 1; i >= 0; i--) {
      if (board[i].every((cell) => cell == 1)) {
        board.removeAt(i);
        board.insert(0, List.generate(boardWidth, (index) => 0));
        linesCleared++;
        i++;
      }
    }

    if (linesCleared > 0) {
      score += linesCleared * 100 * level;
      if (score > level * 1000) {
        level++;
        startTimer();
      }
    }
  }

  void resetGame() {
    timer?.cancel();
    initializeBoard();
    gameStarted = false;
    gameOver = false;
    score = 0;
    level = 1;
    setState(() {});
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
              moveLeft();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowRight:
            case LogicalKeyboardKey.keyD:
              moveRight();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowDown:
            case LogicalKeyboardKey.keyS:
              moveDown();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowUp:
            case LogicalKeyboardKey.keyW:
            case LogicalKeyboardKey.space:
              rotatePiece();
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
            colors: [Color(0xFF2d1b69), Color(0xFF11998e), Color(0xFF38ef7d)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              TetrisHeaderWidget(
                onBackPressed: widget.onBackPressed,
                score: score,
                level: level,
              ),
              TetrisGameBoardWidget(
                board: board,
                currentPiece: currentPiece,
                currentX: currentX,
                currentY: currentY,
                boardWidth: boardWidth,
                boardHeight: boardHeight,
              ),
              TetrisControlsWidget(
                gameStarted: gameStarted,
                gameOver: gameOver,
                score: score,
                onStartGame: startGame,
                onResetGame: resetGame,
                onMoveLeft: moveLeft,
                onMoveRight: moveRight,
                onMoveDown: moveDown,
                onRotate: rotatePiece,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TetrisHeaderWidget extends StatelessWidget {
  final VoidCallback onBackPressed;
  final int score;
  final int level;

  const TetrisHeaderWidget({
    super.key,
    required this.onBackPressed,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tetris',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Klavye: ←→↓ WASD Space',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Skor: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Level: $level',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TetrisGameBoardWidget extends StatelessWidget {
  final List<List<int>> board;
  final List<List<int>> currentPiece;
  final int currentX;
  final int currentY;
  final int boardWidth;
  final int boardHeight;

  const TetrisGameBoardWidget({
    super.key,
    required this.board,
    required this.currentPiece,
    required this.currentX,
    required this.currentY,
    required this.boardWidth,
    required this.boardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Center(
        child: Container(
          width: 260,
          height: 420,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: boardWidth * boardHeight,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: boardWidth,
            ),
            itemBuilder: (context, index) {
              int x = index % boardWidth;
              int y = index ~/ boardWidth;

              bool isCurrentPiece = false;

              // Mevcut parçayı kontrol et
              if (currentPiece.isNotEmpty) {
                for (int i = 0; i < currentPiece.length; i++) {
                  for (int j = 0; j < currentPiece[i].length; j++) {
                    if (currentPiece[i][j] == 1) {
                      int pieceX = currentX + j;
                      int pieceY = currentY + i;

                      if (pieceX == x &&
                          pieceY == y &&
                          pieceX >= 0 &&
                          pieceX < boardWidth &&
                          pieceY >= 0 &&
                          pieceY < boardHeight) {
                        isCurrentPiece = true;
                        break;
                      }
                    }
                  }
                  if (isCurrentPiece) break;
                }
              }

              Color cellColor;
              if (isCurrentPiece) {
                cellColor = Colors.cyan; // Düşen parça
              } else if (board[y][x] == 1) {
                cellColor = Colors.purple; // Yerleşmiş parçalar
              } else {
                cellColor = Colors.white.withOpacity(0.1); // Boş hücreler
              }

              return Container(
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TetrisControlsWidget extends StatelessWidget {
  final bool gameStarted;
  final bool gameOver;
  final int score;
  final VoidCallback onStartGame;
  final VoidCallback onResetGame;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onMoveDown;
  final VoidCallback onRotate;

  const TetrisControlsWidget({
    super.key,
    required this.gameStarted,
    required this.gameOver,
    required this.score,
    required this.onStartGame,
    required this.onResetGame,
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onMoveDown,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Start/Restart Button
        if (!gameStarted && !gameOver)
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: onStartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Oyunu Başlat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

        if (gameOver)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Oyun Bitti!',
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Final Skor: $score',
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
                  child: const Text(
                    'Tekrar Oyna',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

        // Game Controls
        if (gameStarted && !gameOver)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TetrisControlButton(
                  onPressed: onMoveLeft,
                  icon: Icons.keyboard_arrow_left,
                  color: Colors.white.withOpacity(0.1),
                  borderColor: Colors.white.withOpacity(0.3),
                ),
                TetrisControlButton(
                  onPressed: onMoveDown,
                  icon: Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.1),
                  borderColor: Colors.white.withOpacity(0.3),
                ),
                TetrisControlButton(
                  onPressed: onRotate,
                  icon: Icons.rotate_right,
                  color: Colors.purple.withOpacity(0.3),
                  borderColor: Colors.purple.withOpacity(0.5),
                ),
                TetrisControlButton(
                  onPressed: onMoveRight,
                  icon: Icons.keyboard_arrow_right,
                  color: Colors.white.withOpacity(0.1),
                  borderColor: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class TetrisControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final Color borderColor;

  const TetrisControlButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 45),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
