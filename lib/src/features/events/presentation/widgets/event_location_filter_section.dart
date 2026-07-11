import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/features/events/application/event_filter_provider.dart';
import 'event_location_toggle.dart';
import 'event_location_radius_slider.dart';
import 'event_location_search_bar.dart';

class EventLocationFilterSection extends ConsumerWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onClearSearch;

  const EventLocationFilterSection({
    super.key,
    required this.searchController,
    required this.searchFocus,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(eventFilterProvider);
    final notifier = ref.read(eventFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Text(
            tr('filters.location'),
            style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: EventLocationToggle(
            isAroundMe: filterState.isAroundMe,
            onToggle: (val) => notifier.toggleAroundMe(val),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        if (filterState.isAroundMe)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: EventLocationRadiusSlider(
              radius: filterState.radius,
              onChanged: (val) => notifier.updateRadius(val),
            ),
          )
        else
          EventLocationSearchBar(
            controller: searchController,
            focusNode: searchFocus,
            onClear: onClearSearch,
          ),
      ],
    );
  }
}
