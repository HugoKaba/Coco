import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
    required this.onImageSelected,
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
  final ValueChanged<File> onImageSelected;
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
            'clubs.create.info_title'.tr(),
            style: TextStyle(
              fontSize: AppFontSize.xxxl,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          InputLabel(label: 'clubs.create.club_name_label'.tr()),
          AppTextField(
            controller: clubNameController,
            hintText: 'clubs.create.club_name_hint'.tr(),
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.activities_label'.tr()),
          clubCreationDecoratedField(context, _activitySelector(context)),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.description'.tr()),
          AppTextField(
            controller: descriptionController,
            hintText: 'clubs.create.description_hint'.tr(),
            maxLines: 3,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.image_label'.tr()),
          ClubCreationImagePicker(onImageSelected: onImageSelected),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.facilities_label'.tr()),
          AppTextField(
            controller: facilitiesController,
            hintText: 'clubs.create.facilities_hint'.tr(),
            maxLines: 3,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.city_label'.tr()),
          clubCreationDecoratedField(
            context,
            ClubCreationCityAutocomplete(
              cityController: cityController,
              citiesLoaded: citiesLoaded,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.address_label'.tr()),
          AppTextField(
            controller: addressController,
            hintText: 'clubs.create.address_hint'.tr(),
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'clubs.create.phone_label'.tr()),
          AppTextField(
            controller: phoneController,
            hintText: 'clubs.create.phone_hint'.tr(),
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
