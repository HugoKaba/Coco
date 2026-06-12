import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../domain/models/slot_entity.dart';
import '../../domain/repositories/club_repository.dart';

part 'firestore_slot_repository_streams.part.dart';

class FirestoreSlotRepository implements SlotRepository {
  FirestoreSlotRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final _collection = 'slots';

  CollectionReference<Map<String, dynamic>> get _slots =>
      _firestore.collection(_collection);

  @override
  Future<SlotEntity?> getSlotById(String id) async {
    try {
      final doc = await _slots.doc(id).get();
      return doc.exists ? SlotEntity.fromFirestore(doc) : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<SlotEntity>> getSlotsByClubId(String clubId) async =>
      _loadAndSort(clubId);

  @override
  Future<List<SlotEntity>> getUpcomingSlots(String clubId) async {
    final now = DateTime.now();
    final slots = await _loadAndSort(clubId);
    return slots.where((s) => s.endTime.isAfter(now)).toList();
  }

  @override
  Future<List<SlotEntity>> getSlotsByDateRange({
    required String clubId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final slots = await _loadAndSort(clubId);
      final from = startDate.subtract(const Duration(seconds: 1));
      final to = endDate.add(const Duration(seconds: 1));
      return slots
          .where((s) => s.startTime.isAfter(from) && s.startTime.isBefore(to))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SlotEntity>> _loadAndSort(String clubId) async {
    try {
      final snap = await _slots
          .where('clubId', isEqualTo: clubId)
          .limit(100)
          .get();
      final slots = snap.docs.map(SlotEntity.fromFirestore).toList();
      slots.sort((a, b) => a.startTime.compareTo(b.startTime));
      return slots;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<String> createSlot(SlotEntity slot) async {
    final ref = await _slots.add(slot.toFirestore());
    await _createSlotConversation(ref.id, slot);
    return ref.id;
  }

  Future<void> _createSlotConversation(String slotId, SlotEntity slot) async {
    try {
      final chatRef = _firestore.collection('conversations').doc();
      final title =
          '${slot.type.displayName} - ${DateFormat('dd/MM HH:mm').format(slot.startTime)}';
      await chatRef.set({
        'id': chatRef.id,
        'participantIds': [],
        'type': 'slot',
        'slotId': slotId,
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCount': {},
      });
    } catch (_) {}
  }

  @override
  Future<void> updateSlot(SlotEntity slot) =>
      _slots.doc(slot.id).update(slot.toFirestore());
  @override
  Future<void> deleteSlot(String id) => _slots.doc(id).delete();
  @override
  Future<List<String>> getParticipants(String slotId) async =>
      (await getSlotById(slotId))?.participants ?? [];
  @override
  Future<bool> bookSlot(String slotId, String userId) =>
      _bookSlot(this, slotId, userId);
  @override
  Future<bool> cancelBooking(String slotId, String userId) =>
      _cancelBooking(this, slotId, userId);
  @override
  Stream<SlotEntity?> watchSlot(String id) => _watchSlot(this, id);
  @override
  Stream<List<SlotEntity>> watchUpcomingSlots(String clubId) =>
      _watchUpcomingSlots(this, clubId);
}
