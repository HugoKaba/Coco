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
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (club.logoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.network(
                  club.logoUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                ),
              ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(
                      fontSize: AppFontSize.xxl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    ClubSportCatalog.labelsTextFor(club.activities),
                    style: TextStyle(
                      color: Theme.of(s.context).colorScheme.onSurfaceVariant,
                      fontSize: AppFontSize.md,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ClubMembershipButton(clubId: club.id),
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
