import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _ageController;

  String _gender = 'M';
  int _trainingFrequency = 1;
  String _sportsGoal = 'Loisir';

  bool _isLoading = false;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _bioController = TextEditingController();
    _cityController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final userProfileAsync = ref.watch(userProfileProvider);
      userProfileAsync.whenData((profile) {
        if (profile != null) {
          _firstNameController.text = profile.firstName;
          _lastNameController.text = profile.lastName;
          _bioController.text = profile.bio;
          _cityController.text = profile.city;
          _ageController.text = profile.age.toString();
          _gender = profile.gender;
          _trainingFrequency = profile.trainingFrequency;
          _sportsGoal = profile.sportsGoal.isNotEmpty
              ? profile.sportsGoal
              : 'Loisir';
          setState(() {});
        }
      });
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProfileAsync = ref.read(userProfileProvider);
      final currentProfile = userProfileAsync.value;

      if (currentProfile == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile not loaded')));
        }
        return;
      }

      final updatedProfile = currentProfile.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        bio: _bioController.text.trim(),
        city: _cityController.text.trim(),
        age: int.tryParse(_ageController.text) ?? 18,
        gender: _gender,
        trainingFrequency: _trainingFrequency,
        sportsGoal: _sportsGoal,
      );

      final repo = ref.read(profileRepositoryProvider);
      await repo.updateUserProfile(updatedProfile);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profil mis à jour')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final canSave = userProfileAsync.hasValue && userProfileAsync.value != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        actions: [
          IconButton(
            onPressed: (_isLoading || !canSave) ? null : _saveProfile,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check),
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text("Profil introuvable"));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'Prénom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? 'Requis' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? 'Requis' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _gender,
                          decoration: const InputDecoration(
                            labelText: 'Genre',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'M', child: Text('Homme')),
                            DropdownMenuItem(value: 'F', child: Text('Femme')),
                          ],
                          onChanged: (v) => setState(() => _gender = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Ville',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue:
                        [
                          'Loisir',
                          'Compétition',
                          'Perte de poids',
                        ].contains(_sportsGoal)
                        ? _sportsGoal
                        : 'Loisir',
                    decoration: const InputDecoration(
                      labelText: 'Objectif Sportif',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Loisir', child: Text('Loisir')),
                      DropdownMenuItem(
                        value: 'Compétition',
                        child: Text('Compétition'),
                      ),
                      DropdownMenuItem(
                        value: 'Perte de poids',
                        child: Text('Perte de poids'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _sportsGoal = v!),
                  ),
                  const SizedBox(height: 16),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fréquence d\'entrainement (par semaine)',
                      border: OutlineInputBorder(),
                    ),
                    child: Column(
                      children: [
                        Slider(
                          value: _trainingFrequency.toDouble(),
                          min: 0,
                          max: 7,
                          divisions: 7,
                          label: _trainingFrequency.toString(),
                          onChanged: (v) =>
                              setState(() => _trainingFrequency = v.toInt()),
                        ),
                        Text('$_trainingFrequency fois / semaine'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
