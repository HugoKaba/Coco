import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../dark_text_field.dart';
import 'stylish_age_input.dart';
import '../photo_picker_field.dart';
import '../photo_preview_box.dart';

import '../city_autocomplete.dart';
import 'gender_selector_row.dart';

class StepProfileCompletion extends StatelessWidget {
  final Uint8List? profilePhotoBytes;
  final VoidCallback pickProfilePhoto;
  final TextEditingController ageController;
  final TextEditingController zipController;
  final TextEditingController cityController;
  final bool citiesLoaded;
  final Function(bool) setCitiesLoaded;
  final String selectedGender;
  final ValueChanged<String> onGenderSelected;
  final Color accentColor;
  final Color fieldColor;
  final Color innerShadow;

  const StepProfileCompletion({
    super.key,
    required this.profilePhotoBytes,
    required this.pickProfilePhoto,
    required this.ageController,
    required this.zipController,
    required this.cityController,
    required this.citiesLoaded,
    required this.setCitiesLoaded,
    required this.selectedGender,
    required this.onGenderSelected,
    required this.accentColor,
    required this.fieldColor,
    required this.innerShadow,
  });

  Widget _sectionTitle(BuildContext context, String text) => Text(
    text,
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Colors.white70,
      fontWeight: FontWeight.w600,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 12),
          _sectionTitle(context, tr('register.profile_picture')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: PhotoPickerField(
                  profilePhotoBytes: profilePhotoBytes,
                  onTap: pickProfilePhoto,
                  fieldColor: fieldColor,
                  innerShadow: innerShadow,
                ),
              ),
              const SizedBox(width: 16),
              PhotoPreviewBox(profilePhotoBytes: profilePhotoBytes),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, tr('register.birth_date')),
          const SizedBox(height: 8),

          StylishAgeInput(controller: ageController, accentColor: accentColor),
          const SizedBox(height: 16),
          _sectionTitle(context, tr('register.location')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DarkTextField(
                  controller: zipController,
                  hintText: tr('register.postal_code'),
                  keyboardType: TextInputType.number,
                  fieldColor: fieldColor,
                  innerShadow: innerShadow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: CityAutocomplete(
                  cityController: cityController,
                  zipController: zipController,
                  citiesLoaded: citiesLoaded,
                  setCitiesLoaded: setCitiesLoaded,
                  fieldColor: fieldColor,
                  innerShadow: innerShadow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, tr('register.gender')),
          const SizedBox(height: 8),
          GenderSelectorRow(
            selectedGender: selectedGender,
            onGenderSelected: onGenderSelected,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}
