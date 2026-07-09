part of 'club_detail_screen.dart';

Widget _buildClubDetailAppBar(_ClubDetailScreenState s, ClubEntity club) {
  return SliverAppBar(
    expandedHeight: 200,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      background: club.photoUrls.isNotEmpty
          ? Image.network(
              club.photoUrls.first,
              fit: BoxFit.cover,
              cacheWidth: 800,
            )
          : Container(
              color: Theme.of(
                s.context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              child: const Icon(Icons.sports, size: 80),
            ),
    ),
  );
}

Widget _buildClubDetailHeader(_ClubDetailScreenState s, ClubEntity club) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ClubSportCatalog.labelsTextFor(club.activities),
                    style: TextStyle(
                      color: Theme.of(s.context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        s.ref
            .watch(isMemberProvider(club.id))
            .when(
              data: (isMember) => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final service = s.ref.read(clubMembershipServiceProvider);
                      if (isMember) {
                        await service.leaveClub(club.id);
                      } else {
                        await service.joinClub(club.id);
                      }
                      s.ref.invalidate(isMemberProvider(club.id));
                    } catch (e) {
                      if (s.mounted) {
                        ScaffoldMessenger.of(
                          s.context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  icon: Icon(
                    isMember ? Icons.check_circle : Icons.add_circle_outline,
                  ),
                  label: Text(
                    isMember ? 'Membre du Club' : 'Rejoindre le Club',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMember ? Colors.green : null,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
      ],
    ),
  );
}

Widget _buildClubDetailTabs(_ClubDetailScreenState s) {
  return TabBar(
    controller: s._tabController,
    tabs: [
      Tab(text: 'clubs.schedule.upcoming'.tr()),
      Tab(text: 'common.info'.tr()),
      Tab(text: 'clubs.create.opening_hours'.tr()),
    ],
  );
}
