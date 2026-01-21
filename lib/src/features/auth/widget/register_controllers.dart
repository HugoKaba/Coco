import 'package:flutter/material.dart';

class RegisterControllers {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController age = TextEditingController();

  final List<Map<String, dynamic>> selectedSports = [];
  List<int> selectedDays = [];

  int trainingFrequency = 3;

  Map<String, dynamic>? locationData;
  final TextEditingController zip = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController sportCategory = TextEditingController();
  final TextEditingController activityFrequency = TextEditingController();

  List<TextEditingController> get all => [
    firstName,
    lastName,
    username,
    email,
    password,
    age,
    zip,
    city,
    bio,
    sportCategory,
    activityFrequency,
  ];

  void disposeAll() {
    for (final c in all) {
      c.dispose();
    }
  }
}
