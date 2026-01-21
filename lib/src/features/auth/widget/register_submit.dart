import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import '../../../core/city_service.dart';
import 'register_controllers.dart';

Future<void> registerSubmit({
  required BuildContext context,
  required RegisterControllers controllers,
  required Uint8List? profilePhotoBytes,
  required String selectedGender,
  required String dailyPreference,
}) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: controllers.email.text.trim(),
          password: controllers.password.text.trim(),
        );
    final uid = userCredential.user!.uid;

    String? photoUrl;
    if (profilePhotoBytes != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
        "users/$uid/profile.jpg",
      );
      await storageRef.putData(
        profilePhotoBytes,
        SettableMetadata(contentType: "image/jpeg"),
      );
      photoUrl = await storageRef.getDownloadURL();
    }

    final ageInt = int.tryParse(controllers.age.text) ?? 18;
    final birthYear = DateTime.now().year - ageInt;
    final derivedBirthDate = DateTime(birthYear, 1, 1);

    final cityService = CityService.instance;
    final cityData = cityService.findCityByName(controllers.city.text);
    final double lat = cityData?.latitude ?? 48.8566;
    final double lng = cityData?.longitude ?? 2.3522;
    final geoLoc = GeoFirePoint(GeoPoint(lat, lng));

    await FirebaseFirestore.instance.collection("users_test").doc(uid).set({
      "id": uid,
      "firstName": controllers.firstName.text.trim(),
      "lastName": controllers.lastName.text.trim(),
      "username": controllers.username.text.trim(),
      "email": controllers.email.text.trim(),
      "profilePhoto": photoUrl,
      "gender": selectedGender == 'Homme' || selectedGender == 'Male'
          ? 'M'
          : 'F',
      "age": ageInt,
      "birthDate": Timestamp.fromDate(derivedBirthDate),
      "zip": controllers.zip.text.trim(),
      "city": controllers.city.text.trim(),
      "latitude": lat,
      "longitude": lng,
      "coordinates": geoLoc.data,
      "bio": controllers.bio.text.trim(),
      "userSports": controllers.selectedSports,
      "trainingFrequency": controllers.trainingFrequency,
      "sportsGoal": controllers.sportCategory.text.trim(),
      "dailyPreference": dailyPreference,
      "createdAt": FieldValue.serverTimestamp(),
      "days": controllers.selectedDays,
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(tr('register.submit_success'))));
    context.go('/');
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
  }
}
