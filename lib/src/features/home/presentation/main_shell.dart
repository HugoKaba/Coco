import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/app_glass_bottom_bar.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  /// Index de l'onglet Clubs (écran carte à fond clair). Doit rester aligné
  /// avec l'ordre des branches du router et des items ci-dessous.
  static const int _clubsMapIndex = 2;

  @override
  Widget build(BuildContext context) {
    // Sur la carte (fond clair), on force des icônes inactives foncées pour le
    // contraste ; ailleurs (fonds sombres), on garde le blanc translucide.
    final onMap = navigationShell.currentIndex == _clubsMapIndex;
    final inactiveColor = onMap ? Colors.black87 : null;

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: AppGlassBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
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
