import 'package:flutter/material.dart';
import '../models/app.dart';
import 'image_carousel_widget.dart';
import 'project_content_widget.dart';

enum ProjectViewMode {
  normal, // Yarıya yarıya
  imageMode, // Resim büyük, bottom küçük
  contentMode, // Bottom büyük, resim küçük
}

class ResizableProjectLayout extends StatefulWidget {
  final List<String> images;
  final App openApp;
  final VoidCallback onBackPressed;

  const ResizableProjectLayout({
    super.key,
    required this.images,
    required this.openApp,
    required this.onBackPressed,
  });

  @override
  State<ResizableProjectLayout> createState() => _ResizableProjectLayoutState();
}

class _ResizableProjectLayoutState extends State<ResizableProjectLayout> {
  ProjectViewMode _currentMode = ProjectViewMode.normal;
  final ScrollController _scrollController = ScrollController();

  // MODE ORANLARI - DİKEY EKRANI İKİYE BÖL
  double get _imageRatio {
    switch (_currentMode) {
      case ProjectViewMode.normal:
        return 0.5; // %50 - İKİYE BÖL
      case ProjectViewMode.imageMode:
        return 0.65; // %65 resim - DAHA AZ
      case ProjectViewMode.contentMode:
        return 0.35; // %35 resim - DAHA FAZLA
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Removed unused screenWidth variable

    // HER ZAMAN DİKEY LAYOUT KULLAN
    return _buildPortraitLayout(screenHeight);
  }

  Widget _buildPortraitLayout(double screenHeight) {
    final imageHeight = screenHeight * _imageRatio;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // ÜST - RESİMLER
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: ImageCarouselWidget(images: widget.images),
              ),

              // ALT - İÇERİK PANELİ - EXPANDED KULLAN
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      // DRAG HANDLE
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // BAŞLIK VE KONTROLLER - YATAY DÜZENLEMESİ
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // BAŞLIK
                            Expanded(
                              child: Text(
                                widget.openApp.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // MOD KONTROL BUTONLARI - KÜÇÜK
                            _buildControlButtons(),
                          ],
                        ),
                      ),

                      // KAYDIRILABIIR İÇERİK
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            physics: const BouncingScrollPhysics(),
                            child: ProjectContentWidget(
                              openApp: widget.openApp,
                              scrollController: _scrollController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // GERİ BUTONU
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: widget.onBackPressed,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // RESIM BÜYÜK MODU
        _buildModeButton(
          icon: Icons.photo_size_select_large,
          color:
              _currentMode == ProjectViewMode.imageMode
                  ? Colors.blue[400]!
                  : Colors.blue[600]!,
          isActive: _currentMode == ProjectViewMode.imageMode,
          onTap: () => setState(() => _currentMode = ProjectViewMode.imageMode),
        ),

        const SizedBox(width: 6),

        // NORMAL MOD
        _buildModeButton(
          icon: Icons.crop_free,
          color:
              _currentMode == ProjectViewMode.normal
                  ? Colors.green[400]!
                  : Colors.green[600]!,
          isActive: _currentMode == ProjectViewMode.normal,
          onTap: () => setState(() => _currentMode = ProjectViewMode.normal),
        ),

        const SizedBox(width: 6),

        // İÇERİK BÜYÜK MODU
        _buildModeButton(
          icon: Icons.article,
          color:
              _currentMode == ProjectViewMode.contentMode
                  ? Colors.orange[400]!
                  : Colors.orange[600]!,
          isActive: _currentMode == ProjectViewMode.contentMode,
          onTap:
              () => setState(() => _currentMode = ProjectViewMode.contentMode),
        ),
      ],
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: isActive ? Border.all(color: Colors.white, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

class CompactContentWidget extends StatelessWidget {
  const CompactContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey[400], size: 32),
          const SizedBox(height: 8),
          Text(
            'Daha fazla detay için içeriği büyütün',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Sağ alttaki butona tıklayın',
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ProjectLayoutTile extends StatelessWidget {
  final String title;
  final Widget content;

  const ProjectLayoutTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}
