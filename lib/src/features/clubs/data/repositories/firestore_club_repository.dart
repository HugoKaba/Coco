import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import '../../domain/repositories/club_repository.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/club_sport_catalog.dart';

class FirestoreClubRepository implements ClubRepository {
  final FirebaseFirestore _firestore;
  final _collection = 'clubs';

  FirestoreClubRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ClubEntity?> getClubById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return ClubEntity.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ClubEntity>> getClubsByOwnerId(String ownerId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('ownerId', isEqualTo: ownerId)
        .get();
    return snapshot.docs.map((doc) => ClubEntity.fromFirestore(doc)).toList();
  }

  @override
  Future<List<ClubEntity>> searchClubsByLocation({
    required double lat,
    required double lng,
    required double radiusKm,
    List<String>? activities,
  }) async {
    try {
      final center = GeoFirePoint(GeoPoint(lat, lng));
      Query query = _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true);
      final snapshot = await query.get();
      final normalizedActivities = activities == null
          ? const <String>[]
          : ClubSportCatalog.normalizeKeys(activities);
      final clubs = snapshot.docs
          .map((doc) => ClubEntity.fromFirestore(doc))
          .toList();

      return clubs.where((club) {
        if (normalizedActivities.isNotEmpty &&
            club.normalizedActivities.every(
              (activity) => !normalizedActivities.contains(activity),
            )) {
          return false;
        }
        final clubGeoPoint = GeoPoint(club.lat, club.lng);
        final distance = center.distanceBetweenInKm(geopoint: clubGeoPoint);
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> createClub(ClubEntity club) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(club.toFirestore());
    return docRef.id;
  }

  @override
  Future<void> updateClub(ClubEntity club) async {
    await _firestore
        .collection(_collection)
        .doc(club.id)
        .update(club.toFirestore());
  }

  @override
  Future<void> deleteClub(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<List<ClubEntity>> getActiveClubs() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('subscriptionExpiresAt', isGreaterThan: Timestamp.now())
          .get();
      return snapshot.docs.map((doc) => ClubEntity.fromFirestore(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> isSubscriptionActive(String clubId) async {
    final club = await getClubById(clubId);
    return club?.isSubscriptionActive ?? false;
  }

  @override
  Future<void> renewSubscription(String clubId, DateTime newExpiryDate) async {
    await _firestore.collection(_collection).doc(clubId).update({
      'subscriptionExpiresAt': Timestamp.fromDate(newExpiryDate),
    });
  }

  @override
  Stream<ClubEntity?> watchClub(String id) {
    return _firestore.collection(_collection).doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ClubEntity.fromFirestore(doc);
    });
  }
}
