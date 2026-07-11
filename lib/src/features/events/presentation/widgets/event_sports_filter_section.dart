import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/features/events/application/event_filter_provider.dart';

class EventSportsFilterSection extends ConsumerWidget {
  const EventSportsFilterSection({super.key});

  static const List<String> _allSports = [
    "Football",
    "Tennis",
    "Padel",
    "Running",
    "Basketball",
    "Fitness",
    "Crossfit",
    "Volleyball",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSport = ref.watch(
      eventFilterProvider.select((s) => s.selectedSport),
    );
    final notifier = ref.read(eventFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('filters.sports'),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _allSports.map((sport) {
              final isSelected = selectedSport == sport;
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    notifier.setSport(null);
                  } else {
                    notifier.setSport(sport);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                        : Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    sport,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: AppFontSize.sm,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
