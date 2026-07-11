import 'package:easy_localization/easy_localization.dart' hide DateFormat;
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:coco/src/core/providers.dart';
import '../../domain/models/slot_entity.dart';
import 'slot_booking_dialog.dart';

class ClubSlotsCalendar extends ConsumerStatefulWidget {
  final List<SlotEntity> slots;
  final String clubId;

  const ClubSlotsCalendar({
    super.key,
    required this.slots,
    required this.clubId,
  });

  @override
  ConsumerState<ClubSlotsCalendar> createState() => _ClubSlotsCalendarState();
}

class _ClubSlotsCalendarState extends ConsumerState<ClubSlotsCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<SlotEntity> _getSlotsForDay(DateTime day) {
    return widget.slots.where((slot) => _slotOverlapsDay(slot, day)).toList();
  }

  bool _slotOverlapsDay(SlotEntity slot, DateTime day) {
    final startOfDay = DateUtils.dateOnly(day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return slot.startTime.isBefore(endOfDay) &&
        slot.endTime.isAfter(startOfDay);
  }

  void _openDialog(SlotEntity slot) {
    showDialog(
      context: context,
      builder: (_) => SlotBookingDialog(slot: slot, clubId: widget.clubId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedSlots = _getSlotsForDay(_selectedDay);
    final user = ref.watch(authServiceProvider).currentUser;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          child: TableCalendar<SlotEntity>(
            locale: 'fr_FR',
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
            calendarFormat: _calendarFormat,
            eventLoader: _getSlotsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mois',
              CalendarFormat.twoWeeks: '2 semaines',
              CalendarFormat.week: 'Semaine',
            },
            onDaySelected: (selected, focused) => setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            }),
            onFormatChanged: (f) => setState(() => _calendarFormat = f),
            onPageChanged: (f) => setState(() => _focusedDay = f),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              formatButtonTextStyle: TextStyle(
                fontSize: AppFontSize.xs,
                color: theme.colorScheme.onSurface,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 6),
            ),
            daysOfWeekHeight: 20,
            rowHeight: 36,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              markerSize: 4,
              markersMaxCount: 3,
              cellMargin: const EdgeInsets.all(2),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return const SizedBox.shrink();
                return Positioned(
                  bottom: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: events.take(3).map((slot) {
                      final isJoined =
                          user != null && slot.participants.contains(user.uid);
                      return Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isJoined
                              ? Colors.green.shade500
                              : theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Expanded(
          child: selectedSlots.isEmpty
              ? Center(
                  child: Text(
                    'Aucun créneau ce jour',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        DateFormat(
                          'EEEE dd MMMM',
                          'fr_FR',
                        ).format(_selectedDay),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: selectedSlots.length,
                        itemBuilder: (_, i) => _SlotCalendarCard(
                          slot: selectedSlots[i],
                          user: user,
                          onTap: () => _openDialog(selectedSlots[i]),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _SlotCalendarCard extends StatelessWidget {
  final SlotEntity slot;
  final dynamic user;
  final VoidCallback onTap;

  const _SlotCalendarCard({
    required this.slot,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        onTap: onTap,
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
}
