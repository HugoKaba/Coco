// ignore_for_file: invalid_use_of_protected_member
part of 'edit_profile_screen.dart';

Widget _buildProfileForm(_EditProfileScreenState s) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Form(
      key: s._formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: s._firstNameController,
                  labelText: 'Prénom',
                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: AppTextField(
                  controller: s._lastNameController,
                  labelText: 'Nom',
                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: s._ageController,
                  labelText: 'Age',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: s._gender,
                  decoration: appInputDecoration(s.context, label: 'Genre'),
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Homme')),
                    DropdownMenuItem(value: 'F', child: Text('Femme')),
                  ],
                  onChanged: (v) => s.setState(() => s._gender = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: s._cityController,
            labelText: 'Ville',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: s._bioController,
            labelText: 'Bio',
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            initialValue:
                [
                  'Loisir',
                  'Compétition',
                  'Perte de poids',
                ].contains(s._sportsGoal)
                ? s._sportsGoal
                : 'Loisir',
            decoration: appInputDecoration(s.context, label: 'Objectif Sportif'),
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
            onChanged: (v) => s.setState(() => s._sportsGoal = v!),
          ),
          const SizedBox(height: AppSpacing.lg),
          InputDecorator(
            decoration: appInputDecoration(
              s.context,
              label: 'Fréquence d\'entrainement (par semaine)',
            ),
            child: Column(
              children: [
                Slider(
                  value: s._trainingFrequency.toDouble(),
                  min: 0,
                  max: 7,
                  divisions: 7,
                  label: s._trainingFrequency.toString(),
                  onChanged: (v) =>
                      s.setState(() => s._trainingFrequency = v.toInt()),
                ),
                Text('${s._trainingFrequency} fois / semaine'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
