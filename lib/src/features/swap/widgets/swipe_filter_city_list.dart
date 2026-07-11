import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import '../../filters/application/user_search_state.dart';

import '../../filters/domain/models/city.dart';

class SwipeFilterCityList extends StatelessWidget {
  final UserSearchState searchState;
  final ValueChanged<City> onSelectCity;

  const SwipeFilterCityList({
    super.key,
    required this.searchState,
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
          itemCount: searchState.filteredCities.length,
          separatorBuilder: (ctx, i) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final city = searchState.filteredCities[i];
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
