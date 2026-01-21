import 'package:flutter/material.dart';

class RegisterControllers {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController birthDay = TextEditingController();
  final TextEditingController birthMonth = TextEditingController();
  final TextEditingController birthYear = TextEditingController();
  final TextEditingController zip = TextEditingController(text: "93066");
  final TextEditingController city = TextEditingController(text: "Saint-Denis");
  final TextEditingController bio = TextEditingController(text: "À propos de moi...");
  final TextEditingController sportCategory = TextEditingController(text: "Musculation en salle");
  final TextEditingController activityFrequency = TextEditingController(text: "4 fois par semaine");

  List<TextEditingController> get all => [
    firstName, lastName, username, email, password,
    birthDay, birthMonth, birthYear,
    zip, city, bio, sportCategory, activityFrequency,
  ];

  void disposeAll() => all.forEach((c) => c.dispose());
}
