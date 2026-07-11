import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class EventLocationRadiusSlider extends StatelessWidget {
  final double radius;
  final Function(double) onChanged;

  const EventLocationRadiusSlider({
    super.key,
    required this.radius,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr('filters.radius'),
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${radius.toInt()} km',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).primaryColor,
            thumbColor: Colors.white,
            overlayColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(value: radius, min: 5, max: 100, onChanged: onChanged),
        ),
      ],
    );
  }
}
