import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: LiquidGlassBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        activeColor: const Color(0xFFD4913D),
        showLabels: true,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, -10),
        items: [
          LiquidGlassBottomBarItem(
            icon: Icons.grid_view_rounded,
            label: tr('nav.events'),
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.favorite_rounded,
            label: tr('nav.swipe'),
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.chat_bubble_rounded,
            label: tr('nav.chats'),
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.person_rounded,
            label: tr('nav.account'),
          ),
        ],
      ),
    );
  }
}
