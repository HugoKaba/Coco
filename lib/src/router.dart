import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:coco/src/features/swap/swap_page.dart';
import 'package:coco/src/features/home/presentation/main_shell.dart';
import 'package:coco/src/features/events/presentation/events_page.dart';
import 'package:coco/src/features/chats/presentation/chats_page.dart';
import 'package:coco/src/features/profile/presentation/account_page.dart';
import 'core/providers.dart';
import 'features/auth/sign_in_page.dart';
import 'features/settings/settings_page.dart';
import 'features/filters/presentation/pages/filter_screen.dart';

final authChangeNotifierProvider = Provider<ChangeNotifier>((ref) {
  return AuthChangeNotifier(ref);
});

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authChangeNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavKey,
    refreshListenable: refreshListenable,
    initialLocation: '/swipe',
    redirect: (context, state) {
      final user = ref
          .read(authStateChangesProvider)
          .maybeWhen(data: (u) => u, orElse: () => null);
      final isSigningIn = state.location == '/';
      if (user == null && !isSigningIn) return '/';
      if (user != null && isSigningIn) return '/swipe';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SignInPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/events',
                builder: (context, state) => const EventsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/swipe',
                builder: (context, state) => const SwapMatchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chats',
                builder: (context, state) => const ChatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/filters',
        builder: (context, state) => const FilterScreen(),
      ),
    ],
  );
});
