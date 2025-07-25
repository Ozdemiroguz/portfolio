import 'package:flutter/material.dart';
import '../models/app.dart';
import 'project_content_widget.dart';

class ProjectAppWidget extends StatefulWidget {
  final App openApp;

  const ProjectAppWidget({super.key, required this.openApp});

  @override
  State<ProjectAppWidget> createState() => _ProjectAppWidgetState();
}

class _ProjectAppWidgetState extends State<ProjectAppWidget> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  List<String> _projectImages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadProjectImages();
  }

  void _loadProjectImages() {
    // Önce project data'sındaki images'ı kontrol et
    if (widget.openApp.data.isNotEmpty &&
        widget.openApp.data['images'] != null &&
        (widget.openApp.data['images'] as List).isNotEmpty) {
      _projectImages =
          (widget.openApp.data['images'] as List)
              .map((img) => img.toString())
              .toList();
    }
    // Eğer project data'sında images yoksa, app.images'ı kullan
    else if (widget.openApp.images.isNotEmpty) {
      _projectImages = widget.openApp.images;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousImage() {
    if (_currentImageIndex > 0) {
      _currentImageIndex--;
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentImageIndex < _projectImages.length - 1) {
      _currentImageIndex++;
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive tasarım
        bool isLargeScreen = constraints.maxWidth > 800;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Üst boşluk - geri butonu için
              const SizedBox(height: 60),

              // Resim gösterimi - Project data'sından veya app.images'dan
              if (_projectImages.isNotEmpty) ...[
                // Resim container
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: isLargeScreen ? 500 : 400, // Resim boyunu artırdık
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: _projectImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            _projectImages[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[800],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white70,
                                    strokeWidth: 2,
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Kontroller ve göstergeler - resmin altında
                if (_projectImages.length > 1) ...[
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Sol ok butonu
                        GestureDetector(
                          onTap: _currentImageIndex > 0 ? _previousImage : null,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color:
                                  _currentImageIndex > 0
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color:
                                  _currentImageIndex > 0
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                              size: 20,
                            ),
                          ),
                        ),

                        // Sayfa göstergesi (ortada)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _projectImages.length,
                            (index) => Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _currentImageIndex == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Sağ ok butonu
                        GestureDetector(
                          onTap:
                              _currentImageIndex < _projectImages.length - 1
                                  ? _nextImage
                                  : null,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color:
                                  _currentImageIndex < _projectImages.length - 1
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color:
                                  _currentImageIndex < _projectImages.length - 1
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 15),
              ],

              // Proje detayları - boşluk azaltıldı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProjectContentWidget(
                  openApp: widget.openApp,
                  scrollController: ScrollController(),
                ),
              ),

              // Alt boşluk
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
