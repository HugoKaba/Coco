import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/features/filters/domain/models/city.dart';

class EventFilterCityList extends StatelessWidget {
  final List<City> cities;
  final ValueChanged<City> onSelectCity;

  const EventFilterCityList({
    super.key,
    required this.cities,
    required this.onSelectCity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140,
      left: 16,
      right: 16,
      height: 200,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ListView.separated(
          itemCount: cities.length,
          separatorBuilder: (ctx, i) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final city = cities[i];
            return ListTile(
              title: Text(
                city.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(city.zipCodes.join(', ')),
              onTap: () => onSelectCity(city),
            );
          },
        ),
      ),
    );
  }
}
