import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/repositories/club_repository.dart';
import '../../domain/models/slot_entity.dart';

class FirestoreSlotRepository implements SlotRepository {
  final FirebaseFirestore _firestore;
  final _collection = 'slots';

  FirestoreSlotRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<SlotEntity?> getSlotById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return SlotEntity.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<SlotEntity>> getSlotsByClubId(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('clubId', isEqualTo: clubId)
          .limit(100)
          .get();

      final slots = snapshot.docs
          .map((doc) => SlotEntity.fromFirestore(doc))
          .toList();
      slots.sort((a, b) => a.startTime.compareTo(b.startTime));
      return slots;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<SlotEntity>> getUpcomingSlots(String clubId) async {
    // Query ONLY by clubId to avoid composite index requirement (clubId + startTime)
    final snapshot = await _firestore
        .collection(_collection)
        .where('clubId', isEqualTo: clubId)
        .limit(100) // Increased limit since we filter locally
        .get();

    final now = DateTime.now();
    final allSlots = snapshot.docs
        .map((doc) => SlotEntity.fromFirestore(doc))
        .toList();

    // Client-side filtering and sorting
    final upcomingSlots = allSlots
        .where((slot) => slot.startTime.isAfter(now))
        .toList();
    upcomingSlots.sort((a, b) => a.startTime.compareTo(b.startTime));

    return upcomingSlots;
  }

  @override
  Future<List<SlotEntity>> getSlotsByDateRange({
    required String clubId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('clubId', isEqualTo: clubId)
          // .where('startTime', ...) // Removed to avoid index
          .get();

      final allSlots = snapshot.docs
          .map((doc) => SlotEntity.fromFirestore(doc))
          .toList();

      // Client-side filtering
      return allSlots.where((slot) {
        return slot.startTime.isAfter(
              startDate.subtract(const Duration(seconds: 1)),
            ) &&
            slot.startTime.isBefore(endDate.add(const Duration(seconds: 1)));
      }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> createSlot(SlotEntity slot) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(slot.toFirestore());

    // Auto-create conversation for this slot
    try {
      final chatRef = _firestore.collection('conversations').doc();
      final title =
          '${slot.type.displayName} - ${DateFormat('dd/MM HH:mm').format(slot.startTime)}';

      await chatRef.set({
        'id': chatRef.id,
        'participantIds': [],
        'type': 'slot',
        'slotId': docRef.id,
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCount': {},
      });
    } catch (e) {
      // debugPrint('Error auto-creating chat: $e');
    }

    return docRef.id;
  }

  @override
  Future<void> updateSlot(SlotEntity slot) async {
    await _firestore
        .collection(_collection)
        .doc(slot.id)
        .update(slot.toFirestore());
  }

  @override
  Future<void> deleteSlot(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<bool> bookSlot(String slotId, String userId) async {
    try {
      return await _firestore.runTransaction<bool>((transaction) async {
        final docRef = _firestore.collection(_collection).doc(slotId);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) return false;

        final slot = SlotEntity.fromFirestore(snapshot);
        if (slot.isFull) return false;
        if (slot.participants.contains(userId)) return false;

        final updatedParticipants = [...slot.participants, userId];
        transaction.update(docRef, {'participants': updatedParticipants});
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> cancelBooking(String slotId, String userId) async {
    try {
      final docRef = _firestore.collection(_collection).doc(slotId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return false;

      final slot = SlotEntity.fromFirestore(snapshot);
      if (!slot.participants.contains(userId)) return false;

      final updatedParticipants = slot.participants
          .where((id) => id != userId)
          .toList();
      await docRef.update({'participants': updatedParticipants});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getParticipants(String slotId) async {
    final slot = await getSlotById(slotId);
    return slot?.participants ?? [];
  }

  @override
  Stream<SlotEntity?> watchSlot(String id) {
    return _firestore.collection(_collection).doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return SlotEntity.fromFirestore(doc);
    });
  }

  @override
  Stream<List<SlotEntity>> watchUpcomingSlots(String clubId) {
    // We cannot use .where('startTime' > now) inside the query easily with real-time stream
    // without composite index issues usually, but let's try or do client-side filtering on stream.
    // Client-side filtering on stream is safer for now.

    return _firestore
        .collection(_collection)
        .where('clubId', isEqualTo: clubId)
        .limit(100)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          final allSlots = snapshot.docs
              .map((doc) => SlotEntity.fromFirestore(doc))
              .toList();

          final upcomingSlots = allSlots
              .where((slot) => slot.startTime.isAfter(now))
              .toList();
          upcomingSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
          return upcomingSlots;
        });
  }
}
