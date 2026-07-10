import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/features/clubs/application/club_providers.dart';
import 'package:coco/src/features/clubs/domain/models/club_entity.dart';
import 'package:coco/src/features/clubs/domain/models/slot_entity.dart';
import 'package:coco/src/features/clubs/presentation/pages/slot_creation_screen.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_dashboard/club_dashboard_header.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_dashboard/club_dashboard_slots_sliver.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_dashboard/club_dashboard_stats.dart';

class ClubDashboardScreen extends ConsumerWidget {
  const ClubDashboardScreen({super.key, required this.clubId});
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubAsync = ref.watch(clubDetailsProvider(clubId));
    return clubAsync.when(
      data: (club) {
        if (club == null) {
          return Center(child: Text('clubs.no_clubs_found'.tr()));
        }
        return _content(context, ref, club as ClubEntity);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, ClubEntity club) {
    final slotsAsync = ref.watch(upcomingSlotsProvider(clubId));
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ClubDashboardHeader(club: club),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(upcomingSlotsProvider(clubId).future),
                color: AppColors.brand,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: slotsAsync.when(
                        data: (s) =>
                            ClubDashboardStats(slots: s.cast<SlotEntity>()),
                        loading: () => const SizedBox(height: 100),
                        error: (_, __) => const SizedBox(),
                      ),
                    ),
                    SliverToBoxAdapter(child: _titleRow(context)),
                    slotsAsync.when(
                      data: (s) =>
                          ClubDashboardSlotsSliver(slots: s.cast<SlotEntity>()),
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, __) => SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            'Erreur slots: $e',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'clubs.schedule.upcoming'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SlotCreationScreen(clubId: clubId),
              ),
            ),
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.brand,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
