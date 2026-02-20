// ignore_for_file: invalid_use_of_protected_member
part of 'slot_creation_screen.dart';

Widget _buildSlotDateTimePickers(_SlotCreationScreenState s) {
  return Column(
    children: [
      _dateTimeTile(
        s,
        'clubs.slot.start_time'.tr(),
        s._startTime,
        () => _pickStartTime(s),
      ),
      const SizedBox(height: 16),
      _dateTimeTile(
        s,
        'clubs.slot.end_time'.tr(),
        s._endTime,
        () => _pickEndTime(s),
      ),
    ],
  );
}

Widget _dateTimeTile(
  _SlotCreationScreenState s,
  String label,
  DateTime date,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _SlotCreationScreenState._cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _SlotCreationScreenState._bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: _SlotCreationScreenState._accentColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE, MMM dd • HH:mm').format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _pickStartTime(_SlotCreationScreenState s) async {
  final date = await showDatePicker(
    context: s.context,
    initialDate: s._startTime,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 90)),
    builder: (c, child) => _pickerTheme(c, child),
  );
  if (date == null || !s.mounted) return;
  final time = await showTimePicker(
    context: s.context,
    initialTime: TimeOfDay.fromDateTime(s._startTime),
    builder: (c, child) => _pickerTheme(c, child),
  );
  if (time == null) return;
  s.setState(() {
    s._startTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (s._startTime.isAfter(s._endTime)) {
      s._endTime = s._startTime.add(const Duration(hours: 1));
    }
  });
}

Future<void> _pickEndTime(_SlotCreationScreenState s) async {
  final date = await showDatePicker(
    context: s.context,
    initialDate: s._endTime,
    firstDate: s._startTime,
    lastDate: DateTime.now().add(const Duration(days: 90)),
    builder: (c, child) => _pickerTheme(c, child),
  );
  if (date == null || !s.mounted) return;
  final time = await showTimePicker(
    context: s.context,
    initialTime: TimeOfDay.fromDateTime(s._endTime),
    builder: (c, child) => _pickerTheme(c, child),
  );
  if (time == null) return;
  s.setState(
    () => s._endTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ),
  );
}
