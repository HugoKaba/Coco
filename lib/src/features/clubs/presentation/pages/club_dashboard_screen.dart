import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/slot_entity.dart';
import '../../application/club_providers.dart';
import 'slot_creation_screen.dart';

class ClubDashboardScreen extends ConsumerWidget {
  final String clubId;

  const ClubDashboardScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubAsync = ref.watch(clubDetailsProvider(clubId));

    // Remove Scaffold to embed in AccountPage if needed, or keep for standalone
    // But user asked for "usual display". AccountPage has Scaffold.
    // If I return a Widget here, I can put it in AccountPage body.
    // Let's keep Scaffold OFF if we use it in AccountPage, or handle it.
    // Actually AccountPage already has a Scaffold.
    // Let's make this a Widget returning the content. AccountPage will determine if it shows this.

    return clubAsync.when(
      data: (club) => club == null
          ? Center(child: Text('clubs.no_clubs_found'.tr()))
          : _buildDashboardContent(context, ref, club as ClubEntity),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    WidgetRef ref,
    ClubEntity club,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context, club),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  return ref.refresh(upcomingSlotsProvider(clubId).future);
                },
                color: const Color(0xFFCD8232),
                backgroundColor: const Color(0xFF1F1F1F),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildStats(context, ref)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'clubs.schedule.upcoming'.tr(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _navigateToCreateSlot(context),
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color(0xFFCD8232),
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildSlotsList(context, ref),
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

  Widget _buildHeader(BuildContext context, ClubEntity club) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Tableau de bord',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (club.logoUrl != null)
                CircleAvatar(backgroundImage: NetworkImage(club.logoUrl!))
              else
                const CircleAvatar(
                  backgroundColor: Color(0xFFCD8232),
                  child: Icon(Icons.business, color: Colors.white),
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      club.city,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatChip(
                icon: Icons.people,
                label: 'Capacité: ${club.maxCapacity}',
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                icon: Icons.star,
                label: club.subscriptionType.displayName,
                color: const Color(0xFFCD8232),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    Color color = const Color(0xFF2C2C2C),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(upcomingSlotsProvider(clubId));

    return slotsAsync.when(
      data: (slots) {
        final slotsList = slots.cast<SlotEntity>();
        final bookedCount = slotsList.fold(
          0,
          (sum, slot) => sum + slot.participants.length,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Créneaux', '${slotsList.length}'),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Participants', '$bookedCount')),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotsList(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(upcomingSlotsProvider(clubId));

    return slotsAsync.when(
      data: (slots) {
        if (slots.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun créneau prévu',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final slot = slots[index] as SlotEntity;
            return _buildSlotCard(context, slot);
          }, childCount: slots.length),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, __) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            'Erreur slots: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotCard(BuildContext context, SlotEntity slot) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(slot.startTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(slot.startTime).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFCD8232),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.type.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                if (slot.level != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Niveau: ${slot.level}',
                      style: const TextStyle(
                        color: Color(0xFFCD8232),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: slot.isFull
                  ? Colors.red.withValues(alpha: 0.2)
                  : Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${slot.participants.length}/${slot.maxParticipants}',
              style: TextStyle(
                color: slot.isFull ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateSlot(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SlotCreationScreen(clubId: clubId),
      ),
    );
  }
}
