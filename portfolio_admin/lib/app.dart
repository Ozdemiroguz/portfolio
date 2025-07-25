import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/portfolio_theme.dart';
import 'core/utils/localization_service.dart';
import 'core/router/app_router.dart';

class PortfolioApp extends ConsumerStatefulWidget {
  const PortfolioApp({super.key});

  @override
  ConsumerState<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends ConsumerState<PortfolioApp> {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    _initializeLocalization();
  }

  Future<void> _initializeLocalization() async {
    final localizationService = ref.read(localizationServiceProvider);
    final currentLocale = ref.read(currentLocaleProvider);
    await localizationService.loadLocale(currentLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isDarkMode = ref.watch(themeProvider);

        return MaterialApp.router(
          title: 'Portfolio Admin',
          theme: PortfolioTheme.light,
          darkTheme: PortfolioTheme.dark,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: _appRouter.config(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

final themeProvider = StateProvider<bool>((ref) => false);
