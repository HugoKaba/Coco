// ignore_for_file: invalid_use_of_protected_member
part of 'club_discovery_screen.dart';

Widget _buildClubQuickFilters(_ClubDiscoveryScreenState s) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        FilterChip(
          label: Text('clubs.my_clubs'.tr()),
          selected: s._showOnlyMyClubs,
          onSelected: (selected) {
            s.setState(() => s._showOnlyMyClubs = selected);
            s._searchClubs();
          },
          avatar: s._showOnlyMyClubs ? const Icon(Icons.check, size: 16) : null,
        ),
        const SizedBox(width: 8),
        ...ClubSportCatalog.sports.map((sport) {
          final isSelected = s._filters.selectedSports.any(
            (value) => ClubSportCatalog.normalizeKey(value) == sport.key,
          );
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(sport.label),
              selected: isSelected,
              onSelected: (selected) {
                s.setState(() {
                  final sports = Set<String>.from(s._filters.selectedSports);
                  if (selected) {
                    sports.add(sport.key);
                  } else {
                    sports.removeWhere(
                      (value) =>
                          ClubSportCatalog.normalizeKey(value) == sport.key,
                    );
                  }
                  s._filters = s._filters.copyWith(selectedSports: sports);
                });
                s._searchClubs();
              },
            ),
          );
        }),
      ],
    ),
  );
}

Widget _buildClubList(_ClubDiscoveryScreenState s) {
  if (s._isLoading) return const Center(child: CircularProgressIndicator());
  if (s._clubs.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(s.context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'clubs.no_clubs_found'.tr(),
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(s.context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: s._showFilters,
            icon: const Icon(Icons.filter_list),
            label: Text('filters.title'.tr()),
          ),
        ],
      ),
    );
  }
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: s._clubs.length,
    itemBuilder: (_, i) => _clubCard(s, s._clubs[i]),
  );
}

Widget _clubCard(_ClubDiscoveryScreenState s, ClubEntity club) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () => Navigator.of(s.context).push(
        MaterialPageRoute(builder: (_) => ClubDetailScreen(clubId: club.id)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (club.logoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  club.logoUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        s.context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sports,
                      color: Theme.of(s.context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(
                    s.context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.sports,
                  color: Theme.of(s.context).colorScheme.primary,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ClubSportCatalog.labelsTextFor(club.activities),
                    style: TextStyle(
                      color: Theme.of(s.context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
