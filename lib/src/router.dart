import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:coco/src/features/swap/swap_page.dart';
import 'package:coco/src/features/home/presentation/main_shell.dart';
import 'package:coco/src/features/chats/presentation/chats_page.dart';
import 'package:coco/src/features/profile/presentation/account_page.dart';
import 'core/providers.dart';
import 'features/auth/sign_in_page.dart';
import 'features/settings/settings_page.dart';
import 'features/filters/presentation/pages/filter_screen.dart';
import 'features/events/presentation/pages/event_list_screen.dart';
import 'features/auth/register_page.dart';
import 'features/clubs/presentation/pages/club_discovery_screen.dart';
import 'features/clubs/presentation/pages/subscription_selection_screen.dart';
import 'features/clubs/presentation/pages/club_creation_screen.dart';

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
      final isSigningIn = state.matchedLocation == '/';
      final isRegistering = state.matchedLocation == '/register';
      final isProfessionalSignup =
          state.matchedLocation == '/professional-signup';

      if (user == null &&
          !isSigningIn &&
          !isRegistering &&
          !isProfessionalSignup) {
        return '/';
      }
      if (user != null && isSigningIn) return '/swipe';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SignInPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        // L'ordre des branches doit rester identique à l'ordre des items de
        // la barre dans MainShell (index par position). Swipe en premier.
        branches: [
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
                path: '/events',
                builder: (context, state) => const EventListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clubs',
                builder: (context, state) => const ClubDiscoveryScreen(),
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
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavKey,
        path: '/professional-signup',
        builder: (context, state) => const _ProfessionalSignupFlow(),
      ),
    ],
  );
});

class _ProfessionalSignupFlow extends StatelessWidget {
  const _ProfessionalSignupFlow();

  @override
  Widget build(BuildContext context) {
    return SubscriptionSelectionScreen(
      onSubscriptionSelected: (type) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ClubCreationScreen(subscriptionType: type),
          ),
        );
      },
    );
  }
}
