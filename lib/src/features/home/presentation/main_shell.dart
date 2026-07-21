import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/core/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/app_glass_bottom_bar.dart';

/// Clés des navigateurs de chaque branche du shell, dans le même ordre que les
/// branches du router (et que les items de la barre plus bas). Elles permettent,
/// lors d'un re-tap sur l'onglet déjà actif, de dépiler la branche jusqu'à sa
/// racine — y compris les pages poussées impérativement (Réglages, Modifier le
/// profil) que `goBranch(initialLocation: true)` seul ne retire pas.
final List<GlobalKey<NavigatorState>> shellBranchNavigatorKeys = [
  GlobalKey<NavigatorState>(debugLabel: 'branch-swipe'),
  GlobalKey<NavigatorState>(debugLabel: 'branch-events'),
  GlobalKey<NavigatorState>(debugLabel: 'branch-clubs'),
  GlobalKey<NavigatorState>(debugLabel: 'branch-chats'),
  GlobalKey<NavigatorState>(debugLabel: 'branch-account'),
];

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  /// Index de l'onglet Clubs (écran carte à fond clair). Doit rester aligné
  /// avec l'ordre des branches du router et des items ci-dessous.
  static const int _clubsMapIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onClubs = navigationShell.currentIndex == _clubsMapIndex;
    final clubsMapView = ref.watch(clubsMapViewProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Couleur des icônes inactives selon le contexte :
    // - Onglet Clubs en vue CARTE (fond toujours clair) : icônes foncées quel
    //   que soit le thème, pour le contraste.
    // - Onglet Clubs en vue LISTE (fond qui suit le thème) : icônes dynamiques
    //   → claires en mode nuit, foncées en mode jour. Évite le « noir sur noir »
    //   d'une liste sombre avec des icônes foncées.
    // - Ailleurs (fonds sombres immersifs, ex. Swipe) : blanc translucide par
    //   défaut.
    final Color? inactiveColor;
    if (onClubs && clubsMapView) {
      inactiveColor = Colors.black87;
    } else if (onClubs) {
      inactiveColor = isDark ? Colors.white70 : Colors.black87;
    } else {
      inactiveColor = null;
    }

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: AppGlassBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          final reselect = index == navigationShell.currentIndex;
          if (reselect) {
            // Re-tap sur l'onglet actif → retour à la racine de la branche, en
            // retirant aussi les pages poussées impérativement (Réglages,
            // Modifier le profil) que goBranch seul ne dépile pas.
            shellBranchNavigatorKeys[index].currentState?.popUntil(
              (route) => route.isFirst,
            );
          }
          navigationShell.goBranch(index, initialLocation: reselect);
        },
        activeColor: AppColors.brand,
        inactiveColor: inactiveColor,
        showLabels: true,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        // L'ordre doit rester identique à l'ordre des branches du router
        // (StatefulShellRoute) : chaque item correspond à la branche de même
        // index. Swipe en premier (tout à gauche).
        items: [
          AppGlassBottomBarItem(
            icon: Icons.favorite_rounded,
            label: tr('nav.swipe'),
          ),
          AppGlassBottomBarItem(
            icon: Icons.grid_view_rounded,
            label: tr('nav.events'),
          ),
          AppGlassBottomBarItem(
            icon: Icons.sports,
            label: tr('clubs.title'),
          ),
          AppGlassBottomBarItem(
            icon: Icons.chat_bubble_rounded,
            label: tr('nav.chats'),
          ),
          AppGlassBottomBarItem(
            icon: Icons.person_rounded,
            label: tr('nav.account'),
          ),
        ],
      ),
    );
  }
}
