import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_state_provider.dart';

class LocationFilterSection extends ConsumerWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onClearSearch;

  const LocationFilterSection({
    super.key,
    required this.searchController,
    required this.searchFocus,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final criteria = ref.watch(filterProvider);
    final isAroundMe = criteria.isAroundMe;
    final radius = criteria.radius;
    final notifier = ref.read(filterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: _buildToggleOption(
                    context,
                    'Autour de moi',
                    true,
                    isAroundMe,
                    notifier,
                  ),
                ),
                Expanded(
                  child: _buildToggleOption(
                    context,
                    'Choisir une ville',
                    false,
                    isAroundMe,
                    notifier,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isAroundMe)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              focusNode: searchFocus,
              decoration: InputDecoration(
                hintText: 'Rechercher une ville (ex: Paris, 75001)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: onClearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.deepPurple,
                  inactiveTrackColor: Colors.deepPurple.withValues(alpha: 0.2),
                  thumbColor: Colors.deepPurple,
                  overlayColor: Colors.deepPurple.withValues(alpha: 0.1),
                ),
                child: Slider(
                  min: 1000.0,
                  max: 100000.0,
                  divisions: 99,
                  value: radius,
                  onChanged: (v) =>
                      notifier.updateRadius((v / 1000).round() * 1000),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
    BuildContext context,
    String text,
    bool value,
    bool groupValue,
    FilterNotifier notifier,
  ) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () {
        notifier.toggleAroundMe(value);
        if (value) onClearSearch();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
