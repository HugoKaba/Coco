// ignore_for_file: invalid_use_of_protected_member
part of 'edit_profile_screen.dart';

Future<void> _saveProfile(_EditProfileScreenState s) async {
  if (s._formKey.currentState == null || !s._formKey.currentState!.validate()) {
    return;
  }
  s.setState(() => s._isLoading = true);
  try {
    final currentProfile = s.ref.read(userProfileProvider).value;
    if (currentProfile == null) {
      if (s.mounted) {
        ScaffoldMessenger.of(
          s.context,
        ).showSnackBar(SnackBar(content: Text('profile.not_loaded'.tr())));
      }
      return;
    }

    final updatedProfile = currentProfile.copyWith(
      firstName: s._firstNameController.text.trim(),
      lastName: s._lastNameController.text.trim(),
      bio: s._bioController.text.trim(),
      city: s._cityController.text.trim(),
      age: int.tryParse(s._ageController.text) ?? 18,
      gender: s._gender,
      trainingFrequency: s._trainingFrequency,
      sportsGoal: s._sportsGoal,
    );

    await s.ref
        .read(profileRepositoryProvider)
        .updateUserProfile(updatedProfile);
    if (s.mounted) {
      Navigator.pop(s.context);
      ScaffoldMessenger.of(
        s.context,
      ).showSnackBar(SnackBar(content: Text('profile.updated'.tr())));
    }
  } catch (e) {
    if (s.mounted) {
      ScaffoldMessenger.of(
        s.context,
      ).showSnackBar(SnackBar(content: Text(tr('profile.error_prefix', namedArgs: {'error': '$e'}))));
    }
  } finally {
    if (s.mounted) {
      s.setState(() => s._isLoading = false);
    }
  }
}
