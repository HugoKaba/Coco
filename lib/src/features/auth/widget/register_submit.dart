import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'register_controllers.dart';

Future<void> registerSubmit({
  required BuildContext context,
  required RegisterControllers controllers,
  required Uint8List? profilePhotoBytes,
  required DateTime birthDate,
  required String selectedGender,
  required String dailyPreference,
}) async {
  try {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: controllers.email.text.trim(),
      password: controllers.password.text.trim(),
    );
    final uid = userCredential.user!.uid;

    String? photoUrl;
    if (profilePhotoBytes != null) {
      final storageRef = FirebaseStorage.instance.ref().child("users/$uid/profile.jpg");
      await storageRef.putData(profilePhotoBytes, SettableMetadata(contentType: "image/jpeg"));
      photoUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "firstName": controllers.firstName.text.trim(),
      "lastName": controllers.lastName.text.trim(),
      "username": controllers.username.text.trim(),
      "email": controllers.email.text.trim(),
      "photoUrl": photoUrl,
      "gender": selectedGender,
      "birthday": birthDate.toIso8601String(),
      "zip": controllers.zip.text.trim(),
      "city": controllers.city.text.trim(),
      "bio": controllers.bio.text.trim(),
      "sportCategory": controllers.sportCategory.text.trim(),
      "activityFrequency": controllers.activityFrequency.text.trim(),
      "dailyPreference": dailyPreference,
      "createdAt": FieldValue.serverTimestamp(),
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès !"))
    );
    context.go('/');
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"))
    );
  }
}
