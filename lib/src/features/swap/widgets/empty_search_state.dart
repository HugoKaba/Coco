import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            tr('swipe.empty_state'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            tr('swipe.empty_hint'),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
