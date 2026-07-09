String? clubCreationStepError({
  required int step,
  required String email,
  required String password,
  required String clubName,
  required List<String> activities,
  required String description,
  required String city,
  required String address,
}) {
  if (step == 0) {
    if (email.isEmpty || password.length < 6) {
      return 'Email et mot de passe requis (6+ caractères)';
    }
  }

  if (step == 1) {
    if (clubName.isEmpty ||
        activities.isEmpty ||
        description.isEmpty ||
        city.isEmpty ||
        address.isEmpty) {
      return 'Veuillez remplir tous les champs requis';
    }
  }

  return null;
}
