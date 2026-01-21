import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportlinker/src/core/city_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'widget/register_step_widget.dart';
import 'widget/navigation_button.dart';
import 'widget/register_controllers.dart';
import 'widget/register_submit.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final controllers = RegisterControllers();
  final ImagePicker _imagePicker = ImagePicker();

  static const Color _accentColor = Color(0xFFF2A33A);
  static const Color _fieldColor = Color(0xFF1F1F1F);
  static final Color _inputInnerShadow = Colors.black.withOpacity(0.55);

  String _selectedGender = "H", _dailyPreference = "Aucune";
  Uint8List? _profilePhotoBytes;
  DateTime _birthDate = DateTime(1970, 1, 1);
  bool _citiesLoaded = false;
  int step = 0;

  @override
  void initState() {
    super.initState();
    _updateBirthControllers(_birthDate);
    _loadCities();
  }

  Future<void> _loadCities() async {
    await CityService.instance.loadCities();
    if (!mounted) return;
    setState(() => _citiesLoaded = CityService.instance.isLoaded);
  }

  @override
  void dispose() {
    controllers.disposeAll();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        _profilePhotoBytes = await picked.readAsBytes();
        setState(() {});
      }
    } catch (e) { debugPrint("Erreur photo: $e"); }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(primary: _accentColor, surface: Color(0xFF121212), onSurface: Colors.white)
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked != null) setState(() { _birthDate = picked; _updateBirthControllers(picked); });
  }

  void _updateBirthControllers(DateTime date) {
    controllers.birthDay.text = date.day.toString().padLeft(2,'0');
    controllers.birthMonth.text = date.month.toString().padLeft(2,'0');
    controllers.birthYear.text = date.year.toString();
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: RegisterStepWidget(
                  step: step,
                  formKey: _formKey,
                  controllers: controllers,
                  citiesLoaded: _citiesLoaded,
                  setCitiesLoaded: (v) => setState(() => _citiesLoaded = v),
                  profilePhotoBytes: _profilePhotoBytes,
                  pickProfilePhoto: _pickProfilePhoto,
                  pickBirthDate: _pickBirthDate,
                  selectedGender: _selectedGender,
                  onGenderSelected: (g) => setState(() => _selectedGender = g),
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
                NavigationButton(
                  text: "Précédent",
                  alignment: Alignment.centerLeft,
                  onPressed: () { if (step == 0) context.pop(); else setState(() => step--); },
                ),
                NavigationButton(
                  text: step == 2 ? "Valider" : "Suivant",
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    if (step == 0 && !_formKey.currentState!.validate()) return;
                    if (step < 2) setState(() => step++);
                    else registerSubmit(
                      context: context,
                      controllers: controllers,
                      profilePhotoBytes: _profilePhotoBytes,
                      birthDate: _birthDate,
                      selectedGender: _selectedGender,
                      dailyPreference: _dailyPreference,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
