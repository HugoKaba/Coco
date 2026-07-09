import 'package:flutter/material.dart';

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
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: color ?? cs.onSurface),
          ),
        ),
      ],
    );
  }
}
