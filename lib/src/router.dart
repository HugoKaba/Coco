import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sportlinker/src/features/swap/swap_page.dart';
import 'core/providers.dart';
import 'features/auth/sign_in_page.dart';
import 'features/home/home_page.dart';
import 'features/settings/settings_page.dart';

final authChangeNotifierProvider = Provider<ChangeNotifier>((ref) {
  return AuthChangeNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authChangeNotifierProvider);

  return GoRouter(
    refreshListenable: refreshListenable,
    initialLocation: '/',
    redirect: (context, state) {
      final user = ref
          .read(authStateChangesProvider)
          .maybeWhen(data: (u) => u, orElse: () => null);
      final goingToSettings = state.location == '/settings';
      if (goingToSettings && user == null) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final user = ref
              .read(authStateChangesProvider)
              .maybeWhen(data: (u) => u, orElse: () => null);
          if (user == null) return const SignInPage();
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/swipe',
        builder: (context, state) => const SwipeMatchPage(),
      ),
    ],
  );
});
