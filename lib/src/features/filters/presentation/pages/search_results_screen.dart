import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/person_entity.dart';
import '../../domain/services/geolocation_service.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text('${results.length} Résultats')),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun résultat trouvé',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
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
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
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
                        const SizedBox(height: 4),
                        Text(it.metadata['city'] ?? ''),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: it.sports
                              .map(
                                (s) => Chip(
                                  label: Text(
                                    '${s.sportName} (${s.level})',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        distanceLabel,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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
