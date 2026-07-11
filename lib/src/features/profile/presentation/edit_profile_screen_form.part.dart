// ignore_for_file: invalid_use_of_protected_member
part of 'edit_profile_screen.dart';

/// Label au-dessus d'un champ, façon design system (comme la vue swipe).
Widget _labeled(BuildContext context, String label, Widget field) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppTextStyles.sm.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      field,
    ],
  );
}

Widget _buildProfileForm(_EditProfileScreenState s) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Form(
      key: s._formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _labeled(
                  s.context,
                  'Prénom',
                  AppTextField(
                    controller: s._firstNameController,
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _labeled(
                  s.context,
                  'Nom',
                  AppTextField(
                    controller: s._lastNameController,
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _labeled(
                  s.context,
                  'Age',
                  AppTextField(
                    controller: s._ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _labeled(
                  s.context,
                  'Genre',
                  DropdownButtonFormField<String>(
                    initialValue: s._gender,
                    decoration: appInputDecoration(s.context),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Homme')),
                      DropdownMenuItem(value: 'F', child: Text('Femme')),
                    ],
                    onChanged: (v) => s.setState(() => s._gender = v!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'Ville',
            AppTextField(controller: s._cityController),
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'Bio',
            AppTextField(controller: s._bioController, maxLines: 4),
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'Objectif Sportif',
            DropdownButtonFormField<String>(
              initialValue:
                  [
                    'Loisir',
                    'Compétition',
                    'Perte de poids',
                  ].contains(s._sportsGoal)
                  ? s._sportsGoal
                  : 'Loisir',
              decoration: appInputDecoration(s.context),
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
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'Fréquence d\'entrainement (par semaine)',
            InputDecorator(
              decoration: appInputDecoration(s.context),
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
          ),
        ],
      ),
    ),
  );
}
