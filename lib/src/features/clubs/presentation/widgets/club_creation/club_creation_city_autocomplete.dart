import 'package:coco/src/core/city_service.dart';
import 'package:flutter/material.dart';

import 'club_creation_style.dart';

class ClubCreationCityAutocomplete extends StatelessWidget {
  const ClubCreationCityAutocomplete({
    super.key,
    required this.cityController,
    required this.citiesLoaded,
  });

  final TextEditingController cityController;
  final bool citiesLoaded;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<CityData>(
      displayStringForOption: (city) => city.nomStandard,
      optionsBuilder: (value) {
        if (!citiesLoaded || value.text.trim().isEmpty) {
          return const Iterable<CityData>.empty();
        }
        return CityService.instance.searchCities(value.text.trim());
      },
      onSelected: (city) => cityController.text = city.nomStandard,
      fieldViewBuilder: (context, controller, focusNode, _) {
        if (controller.text.isEmpty && cityController.text.isNotEmpty) {
          controller.text = cityController.text;
        }
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Rechercher une ville...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          onChanged: (value) => cityController.text = value,
        );
      },
    );
  }
}

Widget clubCreationDecoratedField(Widget child) => Container(
  decoration: BoxDecoration(
    color: ClubCreationStyle.field,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: ClubCreationStyle.inputInnerShadow(),
        blurRadius: 10,
        offset: const Offset(0, 4),
        spreadRadius: -4,
        blurStyle: BlurStyle.inner,
      ),
    ],
  ),
  child: child,
);
