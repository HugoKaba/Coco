import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EventLocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  const EventLocationSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: tr('filters.search_city'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
