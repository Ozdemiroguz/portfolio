import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/auth_wrapper.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/portfolio/presentation/pages/portfolio_list_page.dart';
import '../../features/portfolio/presentation/pages/portfolio_detail_page.dart';
import '../../features/apps/presentation/pages/apps_management_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthWrapperRoute.page, path: '/', initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: PortfolioListRoute.page, path: '/portfolios'),
    AutoRoute(page: PortfolioDetailRoute.page, path: '/portfolio/:domain'),
    AutoRoute(
      page: AppsManagementRoute.page,
      path: '/portfolio/:portfolioId/apps',
    ),
  ];
}
