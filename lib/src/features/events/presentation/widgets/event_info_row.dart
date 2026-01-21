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
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
          ),
        ),
      ],
    );
  }
}
