import 'package:flutter/material.dart';
import 'package:coco/src/features/auth/widget/dark_text_field.dart';
import 'package:coco/src/features/auth/widget/input_label.dart';

import 'club_creation_style.dart';
import 'club_creation_city_autocomplete.dart';

class ClubCreationInfoStep extends StatelessWidget {
  const ClubCreationInfoStep({
    super.key,
    required this.clubNameController,
    required this.descriptionController,
    required this.cityController,
    required this.addressController,
    required this.phoneController,
    required this.sportType,
    required this.onSportChanged,
    required this.citiesLoaded,
  });

  final TextEditingController clubNameController;
  final TextEditingController descriptionController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final String sportType;
  final ValueChanged<String> onSportChanged;
  final bool citiesLoaded;

  @override
  Widget build(BuildContext context) {
    final shadow = ClubCreationStyle.inputInnerShadow(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations du Club',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),
          const InputLabel(label: 'Nom du club'),
          DarkTextField(
            controller: clubNameController,
            hintText: 'Ex: Tennis Club Paris',
            fieldColor: ClubCreationStyle.field(context),
            innerShadow: shadow,
          ),
          const SizedBox(height: 20),
          const InputLabel(label: 'Sport'),
          clubCreationDecoratedField(context, _sportDropdown(context)),
          const SizedBox(height: 20),
          const InputLabel(label: 'Description'),
          DarkTextField(
            controller: descriptionController,
            hintText: 'Décrivez votre club...',
            maxLines: 3,
            fieldColor: ClubCreationStyle.field(context),
            innerShadow: shadow,
          ),
          const SizedBox(height: 20),
          const InputLabel(label: 'Ville'),
          clubCreationDecoratedField(
            context,
            ClubCreationCityAutocomplete(
              cityController: cityController,
              citiesLoaded: citiesLoaded,
            ),
          ),
          const SizedBox(height: 20),
          const InputLabel(label: 'Adresse'),
          DarkTextField(
            controller: addressController,
            hintText: '123 Rue Example',
            fieldColor: ClubCreationStyle.field(context),
            innerShadow: shadow,
          ),
          const SizedBox(height: 20),
          const InputLabel(label: 'Téléphone (optionnel)'),
          DarkTextField(
            controller: phoneController,
            hintText: '+33 6 12 34 56 78',
            keyboardType: TextInputType.phone,
            fieldColor: ClubCreationStyle.field(context),
            innerShadow: shadow,
          ),
        ],
      ),
    );
  }

  Widget _sportDropdown(BuildContext context) {
    const sports = ['tennis', 'gym', 'football', 'athletics'];
    return DropdownButtonFormField<String>(
      initialValue: sportType,
      dropdownColor: ClubCreationStyle.field(context),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      items: sports
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(s[0].toUpperCase() + s.substring(1)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onSportChanged(value);
      },
    );
  }
}
