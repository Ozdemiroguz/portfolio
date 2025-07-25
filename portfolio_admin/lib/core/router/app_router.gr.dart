// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AppsManagementPage]
class AppsManagementRoute extends PageRouteInfo<AppsManagementRouteArgs> {
  AppsManagementRoute({
    Key? key,
    required String portfolioId,
    List<PageRouteInfo>? children,
  }) : super(
         AppsManagementRoute.name,
         args: AppsManagementRouteArgs(key: key, portfolioId: portfolioId),
         rawPathParams: {'portfolioId': portfolioId},
         initialChildren: children,
       );

  static const String name = 'AppsManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AppsManagementRouteArgs>(
        orElse: () => AppsManagementRouteArgs(
          portfolioId: pathParams.getString('portfolioId'),
        ),
      );
      return AppsManagementPage(key: args.key, portfolioId: args.portfolioId);
    },
  );
}

class AppsManagementRouteArgs {
  const AppsManagementRouteArgs({this.key, required this.portfolioId});

  final Key? key;

  final String portfolioId;

  @override
  String toString() {
    return 'AppsManagementRouteArgs{key: $key, portfolioId: $portfolioId}';
  }
}

/// generated route for
/// [AuthWrapperPage]
class AuthWrapperRoute extends PageRouteInfo<void> {
  const AuthWrapperRoute({List<PageRouteInfo>? children})
    : super(AuthWrapperRoute.name, initialChildren: children);

  static const String name = 'AuthWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthWrapperPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [PortfolioDetailPage]
class PortfolioDetailRoute extends PageRouteInfo<PortfolioDetailRouteArgs> {
  PortfolioDetailRoute({
    Key? key,
    required String domain,
    List<PageRouteInfo>? children,
  }) : super(
         PortfolioDetailRoute.name,
         args: PortfolioDetailRouteArgs(key: key, domain: domain),
         rawPathParams: {'domain': domain},
         initialChildren: children,
       );

  static const String name = 'PortfolioDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PortfolioDetailRouteArgs>(
        orElse: () =>
            PortfolioDetailRouteArgs(domain: pathParams.getString('domain')),
      );
      return PortfolioDetailPage(key: args.key, domain: args.domain);
    },
  );
}

class PortfolioDetailRouteArgs {
  const PortfolioDetailRouteArgs({this.key, required this.domain});

  final Key? key;

  final String domain;

  @override
  String toString() {
    return 'PortfolioDetailRouteArgs{key: $key, domain: $domain}';
  }
}

/// generated route for
/// [PortfolioListPage]
class PortfolioListRoute extends PageRouteInfo<void> {
  const PortfolioListRoute({List<PageRouteInfo>? children})
    : super(PortfolioListRoute.name, initialChildren: children);

  static const String name = 'PortfolioListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PortfolioListPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}
