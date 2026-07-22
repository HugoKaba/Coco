import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/filter_state_provider.dart';
import 'location_mode_toggle.dart';
import 'radius_filter_control.dart';

class LocationFilterSection extends ConsumerWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onClearSearch;
  final Color activeColor;

  const LocationFilterSection({
    super.key,
    required this.searchController,
    required this.searchFocus,
    required this.onClearSearch,
    this.activeColor = AppColors.brand,
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
          child: LocationModeToggle(
            isAroundMe: isAroundMe,
            notifier: notifier,
            onClearSearch: onClearSearch,
          ),
        ),
        if (!isAroundMe)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: searchController,
              focusNode: searchFocus,
              style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'filters.search_city_hint'.tr(),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: onClearSearch,
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(
                  context,
                ).dividerColor.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
          child: RadiusFilterControl(
            radius: radius,
            notifier: notifier,
            activeColor: activeColor,
          ),
        ),
      ],
    );
  }
}
