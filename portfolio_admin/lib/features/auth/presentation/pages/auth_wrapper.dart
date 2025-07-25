import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/auth_provider.dart';
import '../../../portfolio/presentation/pages/portfolio_list_page.dart';
import 'login_page.dart';

@RoutePage()
class AuthWrapperPage extends ConsumerWidget {
  const AuthWrapperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        print(
          'AuthWrapper: User state - ${user != null ? 'Logged in: ${user.email}' : 'Not logged in'}',
        );
        if (user != null) {
          return const PortfolioListPage();
        } else {
          return const LoginPage();
        }
      },
      loading: () {
        print('AuthWrapper: Loading state');
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (error, stack) {
        print('AuthWrapper: Error state: $error');
        return const Scaffold(body: Center(child: Text('Bir hata oluştu')));
      },
    );
  }
}
