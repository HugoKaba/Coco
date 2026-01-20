import 'package:flutter/material.dart';
import '../providers/filter_state_provider.dart';

class RadiusFilterControl extends StatelessWidget {
  final double radius;
  final FilterNotifier notifier;
  final Color activeColor;

  const RadiusFilterControl({
    super.key,
    required this.radius,
    required this.notifier,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rayon de recherche',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(radius / 1000).toStringAsFixed(0)} km',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: activeColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            inactiveTrackColor: activeColor.withValues(alpha: 0.2),
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: 0.1),
          ),
          child: Slider(
            min: 1000.0,
            max: 100000.0,
            divisions: 99,
            value: radius,
            onChanged: (v) => notifier.updateRadius((v / 1000).round() * 1000),
          ),
        ),
      ],
    );
  }
}
