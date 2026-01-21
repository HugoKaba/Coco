import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EventFilterHeader extends StatelessWidget {
  final VoidCallback onReset;

  const EventFilterHeader({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tr('filters.title'),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onReset,
            child: Text(
              tr('filters.reset'),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
