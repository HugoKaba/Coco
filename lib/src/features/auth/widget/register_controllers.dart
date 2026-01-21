import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterControllers {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController birthDay = TextEditingController();
  final TextEditingController birthMonth = TextEditingController();
  final TextEditingController birthYear = TextEditingController();
  final TextEditingController zip = TextEditingController(
    text: tr('register.postal_code_nb'),
  );
  final TextEditingController city = TextEditingController(
    text: tr('register.city'),
  );
  final TextEditingController bio = TextEditingController(
    text: tr('register.about_me'),
  );
  final TextEditingController sportCategory = TextEditingController(
    text: tr('register.sport_category_value'),
  );
  final TextEditingController activityFrequency = TextEditingController(
    text: tr('register.activity_frequency_value'),
  );

  List<TextEditingController> get all => [
    firstName,
    lastName,
    username,
    email,
    password,
    birthDay,
    birthMonth,
    birthYear,
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
