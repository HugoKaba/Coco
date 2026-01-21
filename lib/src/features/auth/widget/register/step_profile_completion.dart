import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../dark_text_field.dart';
import '../photo_picker_field.dart';
import '../photo_preview_box.dart';
import '../gender_option.dart';
import '../city_autocomplete.dart';

class StepProfileCompletion extends StatelessWidget {
  final Uint8List? profilePhotoBytes;
  final VoidCallback pickProfilePhoto;
  final TextEditingController birthDayController;
  final TextEditingController birthMonthController;
  final TextEditingController birthYearController;
  final VoidCallback pickBirthDate;
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
    required this.birthDayController,
    required this.birthMonthController,
    required this.birthYearController,
    required this.pickBirthDate,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Photo de profil",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 24),
          Text(
            "Date de naissance",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DarkTextField(
                  controller: birthDayController,
                  hintText: "01",
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: pickBirthDate,
                  fieldColor: fieldColor,
                  innerShadow: innerShadow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DarkTextField(
                  controller: birthMonthController,
                  hintText: "01",
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: pickBirthDate,
                  fieldColor: fieldColor,
                  innerShadow: innerShadow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DarkTextField(
                  controller: birthYearController,
                  hintText: "1970",
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: pickBirthDate,
                  fieldColor: fieldColor,
                  innerShadow: innerShadow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Localisation",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DarkTextField(
                  controller: zipController,
                  hintText: "93066",
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
          const SizedBox(height: 24),
          Text(
            "Genre",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenderOption(
                  label: "H",
                  selectedGender: selectedGender,
                  onTap: onGenderSelected,
                  accentColor: accentColor),
              GenderOption(
                  label: "F",
                  selectedGender: selectedGender,
                  onTap: onGenderSelected,
                  accentColor: accentColor),
              GenderOption(
                  label: "NB",
                  selectedGender: selectedGender,
                  onTap: onGenderSelected,
                  accentColor: accentColor),
            ],
          ),
        ],
      ),
    );
  }
}
