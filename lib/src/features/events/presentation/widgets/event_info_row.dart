import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

class EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const EventInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? cs.onSurfaceVariant),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: AppFontSize.md, color: color ?? cs.onSurface),
          ),
        ),
      ],
    );
  }
}
