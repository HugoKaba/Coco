part of 'club_detail_screen.dart';

Widget _buildClubDetailSlotsTab(_ClubDetailScreenState s, String clubId) {
  final slotsAsync = s.ref.watch(upcomingSlotsProvider(clubId));
  return slotsAsync.when(
    data: (slots) {
      final list = slots.cast<SlotEntity>();
      if (list.isEmpty) {
        return Center(child: Text('clubs.schedule.no_slots'.tr()));
      }
      return ListView.builder(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        itemCount: list.length,
        itemBuilder: (_, i) => _slotCard(s, list[i]),
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(
      child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
    ),
  );
}

Widget _slotCard(_ClubDetailScreenState s, SlotEntity slot) {
  final user = s.ref.watch(authServiceProvider).currentUser;
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
      onTap: () => showDialog(
        context: s.context,
        builder: (_) => SlotBookingDialog(slot: slot, clubId: s.widget.clubId),
      ),
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
