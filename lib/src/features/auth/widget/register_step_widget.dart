import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'register/step_account_info.dart';
import 'register/step_profile_completion.dart';
import 'register/step_lifestyle.dart';

import 'register_controllers.dart';

class RegisterStepWidget extends StatelessWidget {
  final int step;
  final GlobalKey<FormState> formKey;
  final RegisterControllers controllers;
  final bool citiesLoaded;
  final Function(bool) setCitiesLoaded;
  final Uint8List? profilePhotoBytes;
  final VoidCallback pickProfilePhoto;
  final String selectedGender;
  final ValueChanged<String> onGenderSelected;
  final List<int> selectedDays;
  final ValueChanged<List<int>> onDaysChanged;
  final ValueChanged<List<Map<String, dynamic>>> onSportsChanged;
  final ValueChanged<int> onFrequencyChanged;
  final Color accentColor;
  final Color fieldColor;
  final Color innerShadow;

  const RegisterStepWidget({
    super.key,
    required this.step,
    required this.formKey,
    required this.controllers,
    required this.citiesLoaded,
    required this.setCitiesLoaded,
    required this.profilePhotoBytes,
    required this.pickProfilePhoto,
    required this.selectedGender,
    required this.onGenderSelected,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.onSportsChanged,
    required this.onFrequencyChanged,
    required this.accentColor,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return StepAccountInfo(
          formKey: formKey,
          firstNameController: controllers.firstName,
          nameController: controllers.lastName,
          userNameController: controllers.username,
          emailController: controllers.email,
          passwordController: controllers.password,
          accentColor: accentColor,
          fieldColor: fieldColor,
          innerShadow: innerShadow,
        );
      case 1:
        return StepProfileCompletion(
          ageController: controllers.age,
          zipController: controllers.zip,
          cityController: controllers.city,
          citiesLoaded: citiesLoaded,
          setCitiesLoaded: setCitiesLoaded,
          profilePhotoBytes: profilePhotoBytes,
          pickProfilePhoto: pickProfilePhoto,
          selectedGender: selectedGender,
          onGenderSelected: onGenderSelected,
          accentColor: accentColor,
          fieldColor: fieldColor,
          innerShadow: innerShadow,
        );
      default:
        return StepLifestyle(
          bioController: controllers.bio,
          selectedSports: controllers.selectedSports,
          onSportsChanged: onSportsChanged,
          frequency: controllers.trainingFrequency,
          onFrequencyChanged: onFrequencyChanged,
          selectedDays: selectedDays,
          onDaysChanged: onDaysChanged,
          accentColor: accentColor,
          fieldColor: fieldColor,
          innerShadow: innerShadow,
        );
    }
  }
}
