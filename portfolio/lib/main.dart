import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/portfolio_screen.dart';

void main() async {
  debugPrint('🚀 Uygulama başlatılıyor...');
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('✅ Flutter binding hazır');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase başlatıldı');
  } catch (e) {
    debugPrint('❌ Firebase başlatma hatası: $e');
  }

  debugPrint('🎯 MyApp başlatılıyor...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PortfolioScreen(domain: 'oguz'),
      debugShowCheckedModeBanner: false,
    );
  }
}
