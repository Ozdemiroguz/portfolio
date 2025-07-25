import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../models/app.dart';
import '../services/firebase_service.dart';
import '../widgets/phone_frame.dart';
import '../widgets/phone_ui.dart';
import '../widgets/content_panel.dart';

class PortfolioScreen extends StatefulWidget {
  final String domain;

  const PortfolioScreen({super.key, required this.domain});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Portfolio? portfolio;
  bool isLoading = true;
  bool isFullscreen = false;
  App? currentApp;

  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
  }

  Future<void> _loadPortfolioData() async {
    setState(() => isLoading = true);

    try {
      final portfolioData = await _firebaseService.getPortfolio(widget.domain);

      if (portfolioData == null) {
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        portfolio = portfolioData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (portfolio == null) {
      return const Scaffold(body: Center(child: Text('Portfolio bulunamadı')));
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 320px altında hata ekranı göster
          if (constraints.maxWidth < 320) {
            return _buildTooSmallScreen();
          }

          // Desktop modunda yeterli yer varsa content panel göster (min 1200px)
          final showContentPanel = constraints.maxWidth >= 1200;

          if (showContentPanel) {
            return _buildDesktopLayout();
          } else {
            return _buildPhoneOnlyLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sol taraf - Telefon UI
        Expanded(
          flex: 2,
          child: Center(
            child: SizedBox(
              width: 400,
              height: 800,
              child: PhoneFrame(
                showFrame: !isFullscreen,
                child: PhoneUI(domain: widget.domain),
              ),
            ),
          ),
        ),
        // Sağ taraf - İçerik paneli
        Expanded(
          flex: 1,
          child: ContentPanel(portfolio: portfolio!, currentApp: currentApp),
        ),
      ],
    );
  }

  Widget _buildPhoneOnlyLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ekran boyutuna göre telefon boyutunu hesapla
        final isMobile = constraints.maxWidth < 768;

        double phoneWidth;
        double phoneHeight;

        if (isMobile) {
          // Mobil: FULL EKRAN - Ekran genişliğinin %95'i
          phoneWidth = (constraints.maxWidth * 0.95).clamp(
            300.0,
            constraints.maxWidth * 0.98,
          );
          // Yükseklik de ekranın %95'i
          phoneHeight = (constraints.maxHeight * 0.95).clamp(
            500.0,
            constraints.maxHeight * 0.98,
          );

          // 1:2 oranını korumaya çalış ama full ekranı öncelikle
          final ratioHeight = phoneWidth * 2;
          if (ratioHeight <= phoneHeight) {
            phoneHeight = ratioHeight;
          } else {
            phoneWidth = phoneHeight / 2;
          }
        } else {
          // Tablet: Daha büyük boyut
          phoneWidth = (constraints.maxWidth * 0.6).clamp(400.0, 500.0);
          phoneHeight = phoneWidth * 2;

          // Maksimum yükseklik sınırı
          final maxHeight = constraints.maxHeight * 0.9;
          if (phoneHeight > maxHeight) {
            phoneHeight = maxHeight;
            phoneWidth = phoneHeight / 2;
          }
        }

        return Center(
          child: SizedBox(
            width: phoneWidth,
            height: phoneHeight,
            child: PhoneFrame(
              showFrame: !isFullscreen,
              child: PhoneUI(domain: widget.domain),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTooSmallScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_android,
                size: 80,
                color: Colors.orange.shade300,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ekran Çok Küçük',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'Bu portfolio en az 320px genişlik gerektirir.\nLütfen cihazınızı döndürün veya daha büyük bir ekran kullanın.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Text(
                  'Minimum: 320px genişlik',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
