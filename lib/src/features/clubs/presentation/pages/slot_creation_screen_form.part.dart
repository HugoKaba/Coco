// ignore_for_file: invalid_use_of_protected_member
part of 'slot_creation_screen.dart';

Widget _buildSlotTypeSelector(_SlotCreationScreenState s) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: _SlotCreationScreenState._cardColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white10),
    ),
    child: Row(
      children: SlotType.values.map((type) {
        final isSelected = s._type == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => s.setState(() => s._type = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? _SlotCreationScreenState._accentColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                type.displayName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildSlotCapacityField(_SlotCreationScreenState s) => Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: _SlotCreationScreenState._cardColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white10),
  ),
  child: Column(
    children: [
      Text(
        'clubs.slot.capacity'.tr(),
        style: const TextStyle(color: Colors.white54),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _capacityButton(
            Icons.remove,
            () => s.setState(() {
              if (s._maxParticipants > 1) s._maxParticipants--;
            }),
          ),
          const SizedBox(width: 32),
          Text(
            '${s._maxParticipants}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 32),
          _capacityButton(
            Icons.add,
            () => s.setState(() => s._maxParticipants++),
          ),
        ],
      ),
    ],
  ),
);

Widget _capacityButton(IconData icon, VoidCallback onTap) => InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(30),
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _SlotCreationScreenState._bgColor,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white24),
    ),
    child: Icon(icon, color: Colors.white),
  ),
);
