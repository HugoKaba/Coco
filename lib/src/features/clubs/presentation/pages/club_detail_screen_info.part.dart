part of 'club_detail_screen.dart';

Widget _buildClubDetailAboutTab(ClubEntity club) {
  final location = [
    club.address,
    club.city,
  ].where((s) => s.trim().isNotEmpty).join(', ');

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'clubs.create.description'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          club.description.trim().isEmpty
              ? 'clubs.no_description'.tr()
              : club.description,
        ),
        const SizedBox(height: 24),
        Text(
          'clubs.contact_info'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildClubDetailInfoRow(Icons.place_outlined, location),
        _buildClubDetailInfoRow(Icons.phone_outlined, club.phone),
        _buildClubDetailInfoRow(Icons.email_outlined, club.email),
        _buildClubDetailInfoRow(Icons.language_outlined, club.website),
        _buildClubDetailInfoRow(
          Icons.groups_outlined,
          'clubs.max_capacity_value'.tr(
            namedArgs: {'count': club.maxCapacity.toString()},
          ),
        ),
      ],
    ),
  );
}

/// Ligne d'info avec une icône. Rien n'est affiché si [value] est vide/null,
/// pour éviter des lignes vides quand une asso n'a pas renseigné un champ.
Widget _buildClubDetailInfoRow(IconData icon, String? value) {
  if (value == null || value.trim().isEmpty) {
    return const SizedBox.shrink();
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

Widget _buildClubDetailHoursTab(_ClubDetailScreenState s, ClubEntity club) {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: club.weeklyHours.entries
        .map(
          (entry) => ListTile(
            title: Text(entry.key),
            trailing: Text(
              entry.value.isOpen
                  ? '${entry.value.openTime?.format(s.context)} - ${entry.value.closeTime?.format(s.context)}'
                  : 'Closed',
            ),
          ),
        )
        .toList(),
  );
}
