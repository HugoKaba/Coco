import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/shared/widgets/app_text_field.dart';
import 'package:coco/src/features/auth/widget/input_label.dart';

import '../../../domain/models/club_sport_catalog.dart';
import 'club_creation_image_picker.dart';
import 'club_creation_style.dart';
import 'club_creation_city_autocomplete.dart';

class ClubCreationInfoStep extends StatelessWidget {
  const ClubCreationInfoStep({
    super.key,
    required this.clubNameController,
    required this.descriptionController,
    required this.facilitiesController,
    required this.onImageUploaded,
    required this.cityController,
    required this.addressController,
    required this.phoneController,
    required this.activities,
    required this.onActivitiesChanged,
    required this.citiesLoaded,
  });

  final TextEditingController clubNameController;
  final TextEditingController descriptionController;
  final TextEditingController facilitiesController;
  final ValueChanged<String> onImageUploaded;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final List<String> activities;
  final ValueChanged<List<String>> onActivitiesChanged;
  final bool citiesLoaded;

  @override
  Widget build(BuildContext context) {
    final shadow = ClubCreationStyle.inputInnerShadow(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations du Club',
            style: TextStyle(
              fontSize: AppFontSize.xxxl,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const InputLabel(label: 'Nom du club'),
          AppTextField(
            controller: clubNameController,
            hintText: 'Ex: Tennis Club Paris',
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Activités'),
          clubCreationDecoratedField(context, _activitySelector(context)),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Description'),
          AppTextField(
            controller: descriptionController,
            hintText: 'Décrivez votre club...',
            maxLines: 3,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Image du club (optionnel)'),
          ClubCreationImagePicker(onImageUploaded: onImageUploaded),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Commodités (optionnel)'),
          AppTextField(
            controller: facilitiesController,
            hintText: 'Vestiaires, douches, parking...',
            maxLines: 3,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Ville'),
          clubCreationDecoratedField(
            context,
            ClubCreationCityAutocomplete(
              cityController: cityController,
              citiesLoaded: citiesLoaded,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Adresse'),
          AppTextField(
            controller: addressController,
            hintText: '123 Rue Example',
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          const InputLabel(label: 'Téléphone (optionnel)'),
          AppTextField(
            controller: phoneController,
            hintText: '+33 6 12 34 56 78',
            keyboardType: TextInputType.phone,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
        ],
      ),
    );
  }

  Widget _activitySelector(BuildContext context) {
    final selectedActivities = ClubSportCatalog.ensureKnownKeys(activities);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ClubSportCatalog.sports.map((sport) {
          final isSelected = selectedActivities.contains(sport.key);
          return FilterChip(
            label: Text(sport.label),
            selected: isSelected,
            onSelected: (_) {
              final updated = List<String>.from(selectedActivities);
              if (isSelected) {
                updated.remove(sport.key);
              } else {
                updated.add(sport.key);
              }
              onActivitiesChanged(updated);
            },
          );
        }).toList(),
      ),
    );
  }
}
