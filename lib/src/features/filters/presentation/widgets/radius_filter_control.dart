import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
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
            Text(
              'filters.search_radius'.tr(),
              style: TextStyle(
                fontSize: AppFontSize.sm,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(radius / 1000).toStringAsFixed(0)} km',
              style: TextStyle(
                fontSize: AppFontSize.md,
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
