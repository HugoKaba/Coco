import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../domain/user_profile.dart';

part 'edit_profile_screen_form.part.dart';
part 'edit_profile_screen_save.part.dart';

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

  /// Remplit les champs avec les données du profil, **une seule fois** : appelé
  /// depuis `build` dès que le stream Firestore a fourni le profil. Le flag
  /// [_isInit] garantit qu'on n'écrase pas les saisies de l'utilisateur si le
  /// stream ré-émet ensuite (ex. après la sauvegarde).
  void _populateControllers(UserProfile profile) {
    if (_isInit) return;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _bioController.text = profile.bio;
    _cityController.text = profile.city;
    _ageController.text = profile.age.toString();
    _gender = profile.gender;
    _trainingFrequency = profile.trainingFrequency;
    _sportsGoal = profile.sportsGoal.isNotEmpty ? profile.sportsGoal : 'Loisir';
    _isInit = true;
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

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final canSave = userProfileAsync.hasValue && userProfileAsync.value != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        actions: [
          IconButton(
            onPressed: (_isLoading || !canSave)
                ? null
                : () => _saveProfile(this),
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
            return const Center(child: Text('Profil introuvable'));
          }
          _populateControllers(profile);
          return _buildProfileForm(this);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
