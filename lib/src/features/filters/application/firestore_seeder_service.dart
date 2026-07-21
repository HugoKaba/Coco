import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../clubs/domain/models/club_sport_catalog.dart';
import 'firestore_seeder_payloads.dart';

part 'firestore_seeder_clubs.part.dart';
part 'firestore_seeder_conversations.part.dart';
part 'firestore_seeder_payload_builders.part.dart';
part 'firestore_seeder_slots.part.dart';

class FirestoreSeederService {
  FirestoreSeederService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String myUserId = 'leJAn69mcRcKIHKNmT46UtEDGNu1';
  final FirebaseFirestore _firestore;

  Future<void> seedUsers() async {
    await _deleteCollection('users_test');
    await _createUser(
      id: myUserId,
      firstName: 'Hugo',
      lastName: 'Kaba',
      gender: 'M',
      isHero: true,
    );
    final createdIds = <String>[];
    for (int i = 0; i < 99; i++) {
      createdIds.add(await _createUser());
    }
    final potentialLikers = List.of(createdIds)..shuffle();
    for (int i = 0; i < 5; i++) {
      final fromId = potentialLikers[i];
      await _firestore
          .collection('users_test')
          .doc(fromId)
          .collection('swipes')
          .doc(myUserId)
          .set({
            'from': fromId,
            'to': myUserId,
            'type': 'like',
            'timestamp': FieldValue.serverTimestamp(),
          });
    }
  }

  Future<void> seedClubsAndSlots() => _seedClubsAndSlots(this);
  Future<void> seedEvents() => _seedEvents(this);
  Future<void> seedConversations() => _seedConversations();

  Future<void> _deleteCollection(String path) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore.collection(path).limit(500).get();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<String> _createUser({
    String? id,
    String? firstName,
    String? lastName,
    String? gender,
    bool isHero = false,
  }) async {
    final data = SeederPayloads.user(
      random: Random(),
      isHero: isHero,
      id: id,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
    final docRef = id != null
        ? _firestore.collection('users_test').doc(id)
        : _firestore.collection('users_test').doc();
    await docRef.set(data..['id'] = docRef.id);
    return docRef.id;
  }
}
