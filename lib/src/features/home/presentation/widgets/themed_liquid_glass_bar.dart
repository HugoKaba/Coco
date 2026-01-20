import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  const LiquidGlassBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });
}

class ThemedLiquidGlassBar extends StatelessWidget {
  final List<LiquidGlassBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool showLabels;
  final Color activeColor;

  const ThemedLiquidGlassBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
    this.activeColor = const Color(0xFFD4913D),
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final inactiveColor = isLight ? Colors.grey : Colors.white70;
    const double barH = 70.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: barH,
          decoration: BoxDecoration(
            color: isLight
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isLight
                  ? Colors.grey.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final it = items[i];
              final selected = i == currentIndex;
              final color = selected ? activeColor : inactiveColor;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? (it.activeIcon ?? it.icon) : it.icon,
                        color: color,
                        size: 24,
                      ),
                      if (showLabels) ...[
                        const SizedBox(height: 4),
                        Text(
                          it.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
