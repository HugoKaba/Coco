import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/core/city_service.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'utils/photo_picker_helper.dart';

import 'widget/register_step_widget.dart';

import 'widget/register_controllers.dart';
import 'widget/register_submit.dart';
import 'widget/register/register_navigation_bottom_bar.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final controllers = RegisterControllers();

  static const Color _accentColor = Color(0xFFF2A33A);
  static const Color _fieldColor = Color(0xFF1F1F1F);
  static final Color _inputInnerShadow = Colors.black.withValues(alpha: 0.55);

  String _selectedGender = tr('register.gender_male');

  Uint8List? _profilePhotoBytes;
  bool _citiesLoaded = false;
  int step = 0;

  @override
  void initState() {
    super.initState();
    super.initState();
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
    final bytes = await pickProfilePhotoHelper();
    if (bytes != null) {
      setState(() => _profilePhotoBytes = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(tr('register.title')),
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

                  selectedGender: _selectedGender,
                  onGenderSelected: (g) => setState(() => _selectedGender = g),
                  selectedDays: controllers.selectedDays,
                  onDaysChanged: (d) =>
                      setState(() => controllers.selectedDays = d),
                  onSportsChanged: (s) => setState(() {}),
                  onFrequencyChanged: (f) =>
                      setState(() => controllers.trainingFrequency = f),
                  accentColor: _accentColor,
                  fieldColor: _fieldColor,
                  innerShadow: _inputInnerShadow,
                ),
              ),
            ),
            const SizedBox(height: 20),
            RegisterNavigationBottomBar(
              step: step,
              onPrevious: () {
                if (step == 0) {
                  context.pop();
                } else {
                  setState(() => step--);
                }
              },
              onNext: () {
                if (step == 0 && !_formKey.currentState!.validate()) {
                  return;
                }
                if (step < 2) {
                  setState(() => step++);
                } else {
                  registerSubmit(
                    context: context,
                    controllers: controllers,
                    profilePhotoBytes: _profilePhotoBytes,

                    selectedGender: _selectedGender,
                    dailyPreference: '',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
