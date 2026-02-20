part of 'slot_creation_screen.dart';

Widget _pickerTheme(BuildContext context, Widget? child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: const ColorScheme.dark(
        primary: _SlotCreationScreenState._accentColor,
        surface: _SlotCreationScreenState._cardColor,
        onSurface: Colors.white,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: _SlotCreationScreenState._bgColor,
      ),
    ),
    child: child!,
  );
}

Future<void> _submitSlotForm(_SlotCreationScreenState s) async {
  if (!(s._formKey.currentState?.validate() ?? false)) return;
  s._formKey.currentState?.save();
  final slot = SlotEntity(
    id: '',
    clubId: s.widget.clubId,
    type: s._type,
    startTime: s._startTime,
    endTime: s._endTime,
    maxParticipants: s._maxParticipants,
    participants: [],
    level: s._selectedLevel.name,
    ageGroup: '${s._ageRange.start.round()}-${s._ageRange.end.round()}',
    courtNumber: s._courtNumber,
    isRecurring: s._isRecurring,
    createdAt: DateTime.now(),
  );
  await s.ref.read(slotRepositoryProvider).createSlot(slot);
  if (!s.mounted) return;
  s.ref.invalidate(upcomingSlotsProvider(s.widget.clubId));
  Navigator.of(s.context).pop();
  ScaffoldMessenger.of(s.context).showSnackBar(
    SnackBar(
      content: Text('clubs.slot.created_success'.tr()),
      backgroundColor: _SlotCreationScreenState._accentColor,
    ),
  );
}
