part of 'firestore_slot_repository.dart';

Future<bool> _bookSlot(
  FirestoreSlotRepository repo,
  String slotId,
  String userId,
) async {
  try {
    return await repo._firestore.runTransaction<bool>((tx) async {
      final ref = repo._slots.doc(slotId);
      final snap = await tx.get(ref);
      if (!snap.exists) return false;
      final slot = SlotEntity.fromFirestore(snap);
      if (slot.isFull || slot.participants.contains(userId)) return false;
      tx.update(ref, {
        'participants': [...slot.participants, userId],
      });
      return true;
    });
  } catch (_) {
    return false;
  }
}

Future<bool> _cancelBooking(
  FirestoreSlotRepository repo,
  String slotId,
  String userId,
) async {
  try {
    final ref = repo._slots.doc(slotId);
    final snap = await ref.get();
    if (!snap.exists) return false;
    final slot = SlotEntity.fromFirestore(snap);
    if (!slot.participants.contains(userId)) return false;
    await ref.update({
      'participants': slot.participants.where((id) => id != userId).toList(),
    });
    return true;
  } catch (_) {
    return false;
  }
}

Stream<SlotEntity?> _watchSlot(FirestoreSlotRepository repo, String id) => repo
    ._slots
    .doc(id)
    .snapshots()
    .map((d) => d.exists ? SlotEntity.fromFirestore(d) : null);

Stream<List<SlotEntity>> _watchUpcomingSlots(
  FirestoreSlotRepository repo,
  String clubId,
) {
  return repo._slots
      .where('clubId', isEqualTo: clubId)
      .limit(100)
      .snapshots()
      .map((snap) {
        final now = DateTime.now();
        final slots = snap.docs
            .map(SlotEntity.fromFirestore)
            .where((s) => s.endTime.isAfter(now))
            .toList();
        slots.sort((a, b) => a.startTime.compareTo(b.startTime));
        return slots;
      });
}
