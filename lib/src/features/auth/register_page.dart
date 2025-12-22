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
import 'sign_in_page.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void initState() {
    super.initState();
    _updateBirthControllers(_birthDate);
    _zipController.text = "93066";
    _cityController.text = "Saint-Denis";
    // Charger les villes au démarrage
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
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      String? photoUrl;
      if (_profilePhotoBytes != null) {
        final storageRef =
        FirebaseStorage.instance.ref().child("users/$uid/profile.jpg");

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
      // Rediriger vers la page d'accueil
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  int step = 0;

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
    final auth = ref.read(authServiceProvider);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (step == 0) ...[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: _accentColor,
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            const SizedBox(height: 36),
                            _buildInputLabel("Prénom"),
                            _buildDarkTextField(
                              controller: _firstNameController,
                              hintText: "Firstname",
                            ),
                            const SizedBox(height: 20),
                            _buildInputLabel("Nom"),
                            _buildDarkTextField(
                              controller: _nameController,
                              hintText: "Name",
                            ),
                            const SizedBox(height: 20),
                            _buildInputLabel("Nom d'utilisateur"),
                            _buildDarkTextField(
                              controller: _userNameController,
                              hintText: "Username",
                            ),
                            const SizedBox(height: 20),
                            _buildInputLabel("Email"),
                            _buildDarkTextField(
                              controller: _emailController,
                              hintText: tr('sign_in.email_label'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            _buildInputLabel("Password"),
                            _buildDarkTextField(
                              controller: _passwordController,
                              hintText: tr('sign_in.password_label'),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (step == 1) ...[
                      _buildProfileCompletionStep(context),
                    ],
                    if (step == 2) ...[
                      _buildLifestyleStep(context),
                    ],
                  ],
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
                        backgroundColor: MaterialStateProperty.all(const Color(0xFFCD8232)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
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
                        if (step == 0) {
                          if (!_formKey.currentState!.validate()) return;
                        }
                        if (step < 2) {
                          setState(() => step++);
                        } else {
                          _submit();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFFCD8232)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
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

  // ------------------- Widgets Step 1 & 2 -------------------

  Widget _buildProfileCompletionStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Photo de profile",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPhotoPickerField(),
              ),
              const SizedBox(width: 16),
              _buildPhotoPreviewBox(),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Date de naissance",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDarkTextField(
                  controller: _birthDayController,
                  hintText: "01",
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: _pickBirthDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDarkTextField(
                  controller: _birthMonthController,
                  hintText: "01",
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: _pickBirthDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDarkTextField(
                  controller: _birthYearController,
                  hintText: "1970",
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: _pickBirthDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Localisation",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildDarkTextField(
                  controller: _zipController,
                  hintText: "93066",
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _buildCityAutocomplete(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Genre",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGenderOption("H"),
              _buildGenderOption("F"),
              _buildGenderOption("NB"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Description",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildDarkTextField(
            controller: _bioController,
            maxLines: 3,
          ),
          const SizedBox(height: 22),
          Text(
            "Catégorie de sport",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildDarkTextField(
            controller: _sportCategoryController,
          ),
          const SizedBox(height: 22),
          Text(
            "Fréquence d'activité",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildDarkTextField(
            controller: _activityFrequencyController,
          ),
          const SizedBox(height: 22),
          Text(
            "Préférence journalière",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPreferenceRow(),
        ],
      ),
    );
  }


  Widget _buildDarkTextField({
    required TextEditingController controller,
    String hintText = "",
    TextInputType keyboardType = TextInputType.text,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return _buildInputWrapper(
      borderRadius: 20,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: textAlign,
        maxLines: maxLines,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: false,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: maxLines > 1 ? 18 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerField() {
    final label = _profilePhoto?.name ?? _defaultPhotoLabel;
    return _buildInputWrapper(
      borderRadius: 20,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _pickProfilePhoto,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.photo_library_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPreviewBox() {
    final borderRadius = BorderRadius.circular(18);
    const double size = 70;
    if (_profilePhotoBytes == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: borderRadius,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.memory(
          _profilePhotoBytes!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGenderOption(String value) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _accentColor : Colors.white30,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentColor,
                ),
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceRow() {
    final options = ["Aucune", "L", "M", "M+"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options
          .map(
            (opt) => _buildPreferenceOption(opt),
      )
          .toList(),
    );
  }

  Widget _buildPreferenceOption(String label) {
    final isSelected = _dailyPreference == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _dailyPreference = label;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _accentColor : Colors.white38,
                width: 2,
              ),
              color: isSelected ? Colors.white12 : Colors.transparent,
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: _accentColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentColor,
                ),
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildInputWrapper({required Widget child, double borderRadius = 20}) {
    final borderColor = Colors.white.withOpacity(0.08);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: _inputInnerShadow,
            blurRadius: 15,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCityAutocomplete() {
    if (!_citiesLoaded) {
      CityService.instance.loadCities().then((_) {
        if (mounted) {
          setState(() {
            _citiesLoaded = CityService.instance.isLoaded;
          });
        }
      });
    }
    
    return _buildInputWrapper(
      borderRadius: 20,
      child: Autocomplete<CityData>(
        key: ValueKey('autocomplete_$_citiesLoaded'),
        displayStringForOption: (CityData option) => option.nomStandard,
        optionsBuilder: (TextEditingValue textEditingValue) {
          // Vérifier si les villes sont chargées
          final isLoaded = CityService.instance.isLoaded;
          if (!isLoaded && !_citiesLoaded) {
            // Essayer de charger si pas encore fait
            CityService.instance.loadCities().then((_) {
              if (mounted) {
                setState(() {
                  _citiesLoaded = CityService.instance.isLoaded;
                });
              }
            });
            return const Iterable<CityData>.empty();
          }
          
          if (textEditingValue.text.isEmpty) {
            return const Iterable<CityData>.empty();
          }
          
          final query = textEditingValue.text.trim();
          if (query.isEmpty) {
            return const Iterable<CityData>.empty();
          }
          
          final results = CityService.instance.searchCities(query);
          debugPrint('Recherche "$query": ${results.length} résultats (villes chargées: $isLoaded)');
          return results;
        },
        onSelected: (CityData selection) {
          setState(() {
            _cityController.text = selection.nomStandard;
            _zipController.text = selection.codePostal;
          });
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted,
        ) {
          if (fieldTextEditingController.text.isEmpty && _cityController.text.isNotEmpty) {
            fieldTextEditingController.text = _cityController.text;
          }
          
          return TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Saint-Denis",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: false,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
            onChanged: (String value) {
              _cityController.text = value;
            },
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
              final city = CityService.instance.findCityByName(value);
              if (city != null) {
                setState(() {
                  _zipController.text = city.codePostal;
                });
              }
            },
          );
        },
        optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<CityData> onSelected,
          Iterable<CityData> options,
        ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(12),
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final CityData option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.nomStandard,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            if (option.codePostal.isNotEmpty)
                              Text(
                                option.codePostal,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
