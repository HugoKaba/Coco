import 'package:coco/src/core/providers.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_slots_calendar.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_membership_button.dart';

import '../../application/club_providers.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/club_sport_catalog.dart';
import '../../domain/models/slot_entity.dart';
import '../widgets/slot_booking_dialog.dart';

part 'club_detail_screen_sections.part.dart';
part 'club_detail_screen_info.part.dart';
part 'club_detail_screen_slots.part.dart';

class ClubDetailScreen extends ConsumerStatefulWidget {
  const ClubDetailScreen({super.key, required this.clubId});
  final String clubId;

  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubAsync = ref.watch(clubDetailsProvider(widget.clubId));
    return Scaffold(
      body: clubAsync.when(
        data: (club) => club == null
            ? Center(child: Text('clubs.no_clubs_found'.tr()))
            : _content(club as ClubEntity),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('common.error'.tr())),
      ),
    );
  }

  Widget _content(ClubEntity club) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(upcomingSlotsProvider(widget.clubId).future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildClubDetailAppBar(this, club),
          SliverToBoxAdapter(child: _buildClubDetailHeader(this, club)),
          SliverToBoxAdapter(child: _buildClubDetailTabs(this)),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildClubDetailSlotsTab(this, club.id),
                _buildClubDetailAboutTab(club),
                _buildClubDetailHoursTab(this, club),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
