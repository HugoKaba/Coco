import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/slot_entity.dart';
import '../../application/club_providers.dart';
import '../widgets/slot_booking_dialog.dart';
import 'package:coco/src/core/providers.dart'; // Add import

class ClubDetailScreen extends ConsumerStatefulWidget {
  final String clubId;

  const ClubDetailScreen({super.key, required this.clubId});

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
        data: (club) =>
            club == null ? _buildNotFound() : _buildContent(club as ClubEntity),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildError(),
      ),
    );
  }

  Widget _buildContent(ClubEntity club) {
    return RefreshIndicator(
      onRefresh: () async {
        return ref.refresh(upcomingSlotsProvider(widget.clubId).future);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildAppBar(club),
          SliverToBoxAdapter(child: _buildHeader(club)),
          SliverToBoxAdapter(child: _buildTabs()),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSlotsTab(club.id),
                _buildAboutTab(club),
                _buildHoursTab(club),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ClubEntity club) {
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
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                child: const Icon(Icons.sports, size: 80),
              ),
      ),
    );
  }

  Widget _buildHeader(ClubEntity club) {
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
                      club.sportType,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ref
              .watch(isMemberProvider(club.id))
              .when(
                data: (isMember) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final service = ref.read(clubMembershipServiceProvider);
                        if (isMember) {
                          // Optional: Confirm leaving
                          await service.leaveClub(club.id);
                        } else {
                          await service.joinClub(club.id);
                        }
                        ref.invalidate(isMemberProvider(club.id));
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
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

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: 'clubs.schedule.upcoming'.tr()),
        Tab(text: 'common.info'.tr()),
        Tab(text: 'clubs.create.opening_hours'.tr()),
      ],
    );
  }

  Widget _buildSlotsTab(String clubId) {
    final slotsAsync = ref.watch(upcomingSlotsProvider(clubId));

    return slotsAsync.when(
      data: (slots) {
        final slotsList = slots.cast<SlotEntity>();
        if (slotsList.isEmpty) {
          return Center(child: Text('clubs.schedule.no_slots'.tr()));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 100,
          ),
          itemCount: slotsList.length,
          itemBuilder: (context, index) => _buildSlotCard(slotsList[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(
        child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildSlotCard(SlotEntity slot) {
    final user = ref.watch(authServiceProvider).currentUser;
    final isJoined = user != null && slot.participants.contains(user.uid);

    return Card(
      color: isJoined ? Colors.green.withValues(alpha: 0.2) : null,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isJoined
            ? BorderSide(color: Colors.green.shade400, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) =>
                SlotBookingDialog(slot: slot, clubId: widget.clubId),
          );
        },
        title: Text(
          slot.type.displayName,
          style: isJoined ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        subtitle: Text(DateFormat('MMM dd, HH:mm').format(slot.startTime)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isJoined)
              Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
            Text(
              'clubs.slot.spots_left'.tr(
                namedArgs: {'count': '${slot.availableSpots}'},
              ),
              style: TextStyle(
                color: isJoined ? Colors.green.shade900 : null,
                fontWeight: isJoined ? FontWeight.w500 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab(ClubEntity club) {
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

  Widget _buildHoursTab(ClubEntity club) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: club.weeklyHours.entries.map((entry) {
        return ListTile(
          title: Text(entry.key),
          trailing: Text(
            entry.value.isOpen
                ? '${entry.value.openTime?.format(context)} - ${entry.value.closeTime?.format(context)}'
                : 'Closed',
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotFound() {
    return Center(child: Text('clubs.no_clubs_found'.tr()));
  }

  Widget _buildError() {
    return Center(child: Text('common.error'.tr()));
  }
}
