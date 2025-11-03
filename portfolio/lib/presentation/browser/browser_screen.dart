import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import 'widgets/dino_game_widget.dart';

/// Browser screen - Google çevrimdışı sayfası stili
class BrowserScreen extends StatelessWidget {
  final AppEntity app;

  const BrowserScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Google Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    tr('browser.google'),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.grey[700]),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Logo
                  Text(
                    tr('browser.google'),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF4285F4),
                      letterSpacing: -2,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Error message
                  Text(
                    tr('browser.offline.title'),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    tr('browser.offline.subtitle'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Dino game
                  Container(
                    width: double.infinity,
                    height: 300,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const DinoGameWidget(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Hint text
                  Text(
                    tr('browser.offline.hint'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
