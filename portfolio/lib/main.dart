import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/home/cubit/home_cubit.dart';
import 'presentation/portfolio/cubit/portfolio_cubit.dart';
import 'presentation/portfolio/portfolio_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

/// Custom scroll behavior for web
/// Enables mouse drag scrolling on web
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeCubit>()),
        BlocProvider(create: (_) => sl<PortfolioCubit>()),
      ],
      child: MaterialApp(
        title: 'Portfolio',
        theme: AppTheme.lightTheme,
        scrollBehavior: AppScrollBehavior(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const PortfolioScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
