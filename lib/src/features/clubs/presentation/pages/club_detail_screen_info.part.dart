part of 'club_detail_screen.dart';

Widget _buildClubDetailAboutTab(ClubEntity club) {
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
        Text(club.description),
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
