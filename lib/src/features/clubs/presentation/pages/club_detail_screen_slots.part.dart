part of 'club_detail_screen.dart';

Widget _buildClubDetailSlotsTab(_ClubDetailScreenState s, String clubId) {
  final slotsAsync = s.ref.watch(upcomingSlotsProvider(clubId));

  return slotsAsync.when(
    data: (slots) {
      final list = slots.cast<SlotEntity>();
      return _SlotsWithCalendar(s: s, slots: list, clubId: clubId);
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(
      child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
    ),
  );
}

class _SlotsWithCalendar extends StatefulWidget {
  final _ClubDetailScreenState s;
  final List<SlotEntity> slots;
  final String clubId;

  const _SlotsWithCalendar({
    required this.s,
    required this.slots,
    required this.clubId,
  });

  @override
  State<_SlotsWithCalendar> createState() => _SlotsWithCalendarState();
}

class _SlotsWithCalendarState extends State<_SlotsWithCalendar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(
                text: 'Créneaux',
                icon: Icon(Icons.list_rounded, size: 18),
                iconMargin: EdgeInsets.only(bottom: 2),
              ),
              Tab(
                text: 'Calendrier',
                icon: Icon(Icons.calendar_month_rounded, size: 18),
                iconMargin: EdgeInsets.only(bottom: 2),
              ),
            ],
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              widget.slots.isEmpty
                  ? Center(child: Text('clubs.schedule.no_slots'.tr()))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: widget.slots.length,
                      itemBuilder: (_, i) =>
                          _slotCard(widget.s, widget.slots[i]),
                    ),
              ClubSlotsCalendar(
                slots: widget.slots,
                clubId: widget.clubId,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


Widget _slotCard(_ClubDetailScreenState s, SlotEntity slot) {
  final user = s.ref.watch(authServiceProvider).currentUser;
  final isJoined = user != null && slot.participants.contains(user.uid);

  return Card(
    color: isJoined ? Colors.green.withValues(alpha: 0.2) : null,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
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
