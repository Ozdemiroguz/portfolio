import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

/// Dinozor zıplama oyunu - Google çevrimdışı sayfası stili
class DinoGameWidget extends StatefulWidget {
  const DinoGameWidget({super.key});

  @override
  State<DinoGameWidget> createState() => _DinoGameWidgetState();
}

class _DinoGameWidgetState extends State<DinoGameWidget> {
  bool _gameStarted = false;
  bool _gameOver = false;
  double _dinoY = 0.0; // Dinozorun Y pozisyonu (0 = yerde, 1 = havada)
  double _dinoVelocity = 0.0;
  double _obstacleX = 1.0; // Engel X pozisyonu (1 = sağda başlangıç, 0 = solda çarpışma)
  int _score = 0;
  Timer? _gameTimer;
  double _gameSpeed = 0.02;
  final double _gravity = 0.001;
  final double _jumpStrength = 0.025;
  final double _groundY = 0.75; // Zemin Y pozisyonu

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _gameOver = false;
      _dinoY = 0.0;
      _dinoVelocity = 0.0;
      _obstacleX = 1.0;
      _score = 0;
      _gameSpeed = 0.02;
    });

    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_gameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        // Dinozor fiziği
        if (_dinoY > 0) {
          _dinoVelocity -= _gravity;
          _dinoY += _dinoVelocity;
          if (_dinoY < 0) {
            _dinoY = 0;
            _dinoVelocity = 0;
          }
        }

        // Engel hareketi
        _obstacleX -= _gameSpeed;
        if (_obstacleX < -0.2) {
          _obstacleX = 1.2;
          _score += 10;
          _gameSpeed += 0.001; // Hız artışı
        }

        // Çarpışma kontrolü
        if (_obstacleX < 0.15 && _obstacleX > 0.05 && _dinoY < 0.15) {
          _gameOver = true;
          timer.cancel();
        }
      });
    });
  }

  void _jump() {
    if (!_gameStarted) {
      _startGame();
      return;
    }

    if (!_gameOver && _dinoY == 0) {
      setState(() {
        _dinoVelocity = _jumpStrength;
        _dinoY += _dinoVelocity;
      });
    }
  }

  void _resetGame() {
    _gameTimer?.cancel();
    setState(() {
      _gameStarted = false;
      _gameOver = false;
      _dinoY = 0.0;
      _dinoVelocity = 0.0;
      _obstacleX = 1.0;
      _score = 0;
      _gameSpeed = 0.02;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space ||
              event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _jump();
          }
        }
      },
      child: GestureDetector(
        onTap: _jump,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              // Zemin
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    border: Border(
                      top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                    ),
                  ),
                ),
              ),

              // Dinozor
              Positioned(
                left: MediaQuery.of(context).size.width * 0.2,
                bottom: MediaQuery.of(context).size.height * _groundY +
                    (_dinoY * MediaQuery.of(context).size.height * 0.3),
                child: _buildDino(),
              ),

              // Engel (Kaktüs)
              Positioned(
                left: MediaQuery.of(context).size.width * _obstacleX,
                bottom: MediaQuery.of(context).size.height * _groundY,
                child: _buildObstacle(),
              ),

              // Skor
              Positioned(
                top: 40,
                right: 40,
                child: Text(
                  '${tr('browser.game.score')}: $_score',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF757575),
                  ),
                ),
              ),

              // Game Over overlay
              if (_gameOver)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tr('browser.game.gameOver'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${tr('browser.game.finalScore')}: $_score',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _resetGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: Text(tr('browser.game.restart')),
                        ),
                      ],
                    ),
                  ),
                ),

              // Başlangıç mesajı
              if (!_gameStarted && !_gameOver)
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      tr('browser.game.pressToStart'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDino() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF757575),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          '🦕',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildObstacle() {
    return Container(
      width: 30,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF757575),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          '🌵',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

