// ignore_for_file: invalid_use_of_protected_member
part of 'edit_profile_screen.dart';

Widget _buildProfileForm(_EditProfileScreenState s) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Form(
      key: s._formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: s._firstNameController,
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
                  controller: s._lastNameController,
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
                  controller: s._ageController,
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
                  initialValue: s._gender,
                  decoration: const InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Homme')),
                    DropdownMenuItem(value: 'F', child: Text('Femme')),
                  ],
                  onChanged: (v) => s.setState(() => s._gender = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: s._cityController,
            decoration: const InputDecoration(
              labelText: 'Ville',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: s._bioController,
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
                ].contains(s._sportsGoal)
                ? s._sportsGoal
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
            onChanged: (v) => s.setState(() => s._sportsGoal = v!),
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
