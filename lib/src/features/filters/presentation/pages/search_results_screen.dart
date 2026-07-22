import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/person_entity.dart';
import '../../domain/services/geolocation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/data/reference_tables.dart';

class SearchResultsScreen extends ConsumerWidget {
  final List<PersonEntity> results;
  final double centerLat;
  final double centerLng;

  const SearchResultsScreen({
    super.key,
    required this.results,
    required this.centerLat,
    required this.centerLng,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = const GeolocationService();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(
            'filters.results_count',
            namedArgs: {'count': '${results.length}'},
          ),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 48,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'filters.no_results'.tr(),
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.sm),
              itemCount: results.length,
              itemBuilder: (context, i) {
                final it = results[i];
                final d = service.distanceMeters(
                  centerLat,
                  centerLng,
                  it.lat,
                  it.lng,
                );
                final km = (d / 1000).ceil();
                final distanceLabel = '${km < 1 ? 1 : km} km';

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xs,
                    horizontal: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade50,
                      child: Text(
                        it.fullName.isNotEmpty
                            ? it.fullName.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    title: Text(
                      it.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xs),
                        Text(it.metadata['city'] ?? ''),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: 4,
                          children: it.sports.map((s) {
                            final sportName = ReferenceTables.getSportName(
                              s.sportId,
                            );
                            final levelName = ReferenceTables.getLevelName(
                              s.levelId,
                            );
                            return Chip(
                              label: Text(
                                '${tr(sportName)} (${tr(levelName)})',
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        distanceLabel,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontSize.xs,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
