import 'package:flutter/material.dart';
import '../models/app.dart';

class AboutLayout extends StatelessWidget {
  final App app;

  const AboutLayout({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Column(
        children: [
          // HEADER - Geri butonu
          _buildHeader(context),

          // CONTENT - Tam sayfa kaydırılabilir
          Expanded(child: _buildScrollableContent()),
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // RESİM KISMI - Sabit yükseklik
              SizedBox(
                height: 400, // Sabit 400px yükseklik
                child: _buildImageSection(),
              ),

              const SizedBox(height: 20),

              // BİLGİLER KISMI - Kaydırılabilir içerik
              _buildContentInfo(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AÇIKLAMA
            if (app.description.isNotEmpty) ...[
              Text(
                app.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 25),
            ],

            // ABOUT BİLGİLERİ
            if (app.data.isNotEmpty) ...[_buildAboutContent(app.data)],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Row(
        children: [
          // GERİ BUTONU - Project'teki gibi
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // BAŞLIK
          Expanded(
            child: Text(
              app.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildImageCarousel(),
      ),
    );
  }

  Widget _buildImageCarousel() {
    if (app.images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey.shade900],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.white54, size: 80),
              SizedBox(height: 10),
              Text(
                'Fotoğraf Yok',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (app.images.length == 1) {
      // Tek resim varsa
      return Image.network(
        app.images[0],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade800, Colors.grey.shade900],
              ),
            ),
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white54, size: 50),
            ),
          );
        },
      );
    }

    // Birden fazla resim varsa carousel
    return PageView.builder(
      itemCount: app.images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.network(
              app.images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade800, Colors.grey.shade900],
                    ),
                  ),
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
            // SAYFA GÖSTERGESİ
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${index + 1}/${app.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutContent(Map<String, dynamic> data) {
    // Bu widget artık kullanılmıyor - AboutAppWidget kullanılıyor
    return const SizedBox.shrink();
  }
}
