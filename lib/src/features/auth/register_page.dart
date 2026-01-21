import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:sportlinker/src/core/city_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'widget/register/step_account_info.dart';
import 'widget/register/step_profile_completion.dart';
import 'widget/register/step_lifestyle.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _birthDayController = TextEditingController();
  final _birthMonthController = TextEditingController();
  final _birthYearController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController(text: "À propos de moi...");
  final _sportCategoryController = TextEditingController(text: "Musculation en salle");
  final _activityFrequencyController = TextEditingController(text: "4 fois par semaine");

  final ImagePicker _imagePicker = ImagePicker();

  static const Color _accentColor = Color(0xFFF2A33A);
  static const Color _fieldColor = Color(0xFF1F1F1F);
  static final Color _inputInnerShadow = Colors.black.withOpacity(0.55);
  static const String _defaultPhotoLabel = "image.jpg";

  String _selectedGender = "H";
  String _dailyPreference = "Aucune";
  XFile? _profilePhoto;
  Uint8List? _profilePhotoBytes;
  DateTime _birthDate = DateTime(1970, 1, 1);
  bool _citiesLoaded = false;
  int step = 0;

  @override
  void initState() {
    super.initState();
    _updateBirthControllers(_birthDate);
    _zipController.text = "93066";
    _cityController.text = "Saint-Denis";
    _loadCities();
  }

  Future<void> _loadCities() async {
    await CityService.instance.loadCities();
    if (mounted) {
      setState(() {
        _citiesLoaded = CityService.instance.isLoaded;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _birthDayController.dispose();
    _birthMonthController.dispose();
    _birthYearController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    _sportCategoryController.dispose();
    _activityFrequencyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      String? photoUrl;
      if (_profilePhotoBytes != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("users/$uid/profile.jpg");

        await storageRef.putData(
          _profilePhotoBytes!,
          SettableMetadata(contentType: "image/jpeg"),
        );

        photoUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "firstName": _firstNameController.text.trim(),
        "lastName": _nameController.text.trim(),
        "username": _userNameController.text.trim(),
        "email": _emailController.text.trim(),
        "photoUrl": photoUrl,
        "gender": _selectedGender,
        "birthday": _birthDate.toIso8601String(),
        "zip": _zipController.text.trim(),
        "city": _cityController.text.trim(),
        "bio": _bioController.text.trim(),
        "sportCategory": _sportCategoryController.text.trim(),
        "activityFrequency": _activityFrequencyController.text.trim(),
        "dailyPreference": _dailyPreference,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès !")),
      );

      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _profilePhoto = picked;
          _profilePhotoBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint("Erreur sélection photo: $e");
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(1900, 1, 1);
    final lastDate = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _accentColor,
              surface: Color(0xFF121212),
              onSurface: Colors.white,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _updateBirthControllers(picked);
      });
    }
  }

  void _updateBirthControllers(DateTime date) {
    _birthDayController.text = date.day.toString().padLeft(2, '0');
    _birthMonthController.text = date.month.toString().padLeft(2, '0');
    _birthYearController.text = date.year.toString().padLeft(4, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(tr('sign_in.title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: step == 0
                    ? StepAccountInfo(
                  formKey: _formKey,
                  firstNameController: _firstNameController,
                  nameController: _nameController,
                  userNameController: _userNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  accentColor: _accentColor,
                  fieldColor: _fieldColor,
                  innerShadow: _inputInnerShadow,
                )
                    : step == 1
                    ? StepProfileCompletion(
                  birthDayController: _birthDayController,
                  birthMonthController: _birthMonthController,
                  birthYearController: _birthYearController,
                  zipController: _zipController,
                  cityController: _cityController,
                  citiesLoaded: _citiesLoaded,
                  setCitiesLoaded: (loaded) => setState(() => _citiesLoaded = loaded),
                  profilePhotoBytes: _profilePhotoBytes,
                  pickProfilePhoto: _pickProfilePhoto,
                  pickBirthDate: _pickBirthDate,
                  selectedGender: _selectedGender,
                  onGenderSelected: (g) => setState(() => _selectedGender = g),
                  accentColor: _accentColor,
                  fieldColor: _fieldColor,
                  innerShadow: _inputInnerShadow,
                )
                    : StepLifestyle(
                  bioController: _bioController,
                  sportCategoryController: _sportCategoryController,
                  activityFrequencyController: _activityFrequencyController,
                  dailyPreference: _dailyPreference,
                  onPreferenceSelected: (p) => setState(() => _dailyPreference = p),
                  accentColor: _accentColor,
                  fieldColor: _fieldColor,
                  innerShadow: _inputInnerShadow,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        if (step == 0) {
                          context.pop();
                        } else {
                          setState(() {
                            step--;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFCD8232)),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14)),
                      ),
                      child: const Text('Précédent'),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if (step == 0 && !_formKey.currentState!.validate()) return;
                        if (step < 2) {
                          setState(() => step++);
                        } else {
                          _submit();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFCD8232)),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14)),
                      ),
                      child: Text(step == 2 ? "Valider" : "Suivant"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
