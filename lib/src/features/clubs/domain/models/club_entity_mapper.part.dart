part of 'club_entity.dart';

ClubEntity _clubCopyWith(
  ClubEntity c, {
  String? id,
  String? ownerId,
  String? name,
  List<String>? activities,
  String? description,
  List<String>? facilities,
  String? address,
  String? city,
  double? lat,
  double? lng,
  String? logoUrl,
  List<String>? photoUrls,
  Map<String, OpeningHours>? weeklyHours,
  int? maxCapacity,
  DateTime? createdAt,
  SubscriptionType? subscriptionType,
  DateTime? subscriptionExpiresAt,
  bool? isActive,
  String? phone,
  String? email,
  String? website,
}) {
  return ClubEntity(
    id: id ?? c.id,
    ownerId: ownerId ?? c.ownerId,
    name: name ?? c.name,
    activities: activities ?? c.activities,
    description: description ?? c.description,
    facilities: facilities ?? c.facilities,
    address: address ?? c.address,
    city: city ?? c.city,
    lat: lat ?? c.lat,
    lng: lng ?? c.lng,
    logoUrl: logoUrl ?? c.logoUrl,
    photoUrls: photoUrls ?? c.photoUrls,
    weeklyHours: weeklyHours ?? c.weeklyHours,
    maxCapacity: maxCapacity ?? c.maxCapacity,
    createdAt: createdAt ?? c.createdAt,
    subscriptionType: subscriptionType ?? c.subscriptionType,
    subscriptionExpiresAt: subscriptionExpiresAt ?? c.subscriptionExpiresAt,
    isActive: isActive ?? c.isActive,
    phone: phone ?? c.phone,
    email: email ?? c.email,
    website: website ?? c.website,
  );
}

ClubEntity _clubFromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  DateTime parseDate(dynamic v) => v is Timestamp
      ? v.toDate()
      : (v is String ? DateTime.tryParse(v) ?? DateTime.now() : DateTime.now());
  Map<String, OpeningHours> parseHours(dynamic v) => v is Map
      ? v.map(
          (k, val) => MapEntry(
            k.toString(),
            OpeningHours.fromMap(val as Map<String, dynamic>),
          ),
        )
      : {};
  List<String> parseActivities(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return [v];
    return [];
  }

  List<String> parseFacilities(dynamic v) {
    if (v is List) {
      return v
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  List<String> parsePhotoUrls(Map<String, dynamic> data) {
    final photoUrls = data['photoUrls'];
    if (photoUrls is List) {
      return photoUrls
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final singlePhoto = data['photoUrl'] ?? data['imageUrl'];
    if (singlePhoto is String && singlePhoto.trim().isNotEmpty) {
      return [singlePhoto.trim()];
    }

    return [];
  }

  final activities = ClubSportCatalog.ensureKnownKeys(
    parseActivities(data['activities']),
  );

  return ClubEntity(
    id: doc.id,
    ownerId: data['ownerId']?.toString() ?? '',
    name: data['name']?.toString() ?? '',
    activities: activities,
    description: data['description']?.toString() ?? '',
    facilities: parseFacilities(data['facilities']),
    address: data['address']?.toString() ?? '',
    city: data['city']?.toString() ?? '',
    lat: (data['lat'] as num?)?.toDouble() ?? 0,
    lng: (data['lng'] as num?)?.toDouble() ?? 0,
    logoUrl: data['logoUrl']?.toString(),
    photoUrls: parsePhotoUrls(data),
    weeklyHours: parseHours(data['weeklyHours']),
    maxCapacity: (data['maxCapacity'] as num?)?.toInt() ?? 0,
    createdAt: parseDate(data['createdAt']),
    subscriptionType: SubscriptionType.values.firstWhere(
      (e) => e.name == data['subscriptionType'],
      orElse: () => SubscriptionType.monthly,
    ),
    subscriptionExpiresAt: parseDate(data['subscriptionExpiresAt']),
    isActive: data['isActive'] as bool? ?? true,
    phone: data['phone']?.toString(),
    email: data['email']?.toString(),
    website: data['website']?.toString(),
  );
}

Map<String, dynamic> _clubToFirestore(ClubEntity c) => {
  'ownerId': c.ownerId,
  'name': c.name,
  'activities': c.normalizedActivities,
  'description': c.description,
  if (c.facilities.isNotEmpty) 'facilities': c.facilities,
  'address': c.address,
  'city': c.city,
  'lat': c.lat,
  'lng': c.lng,
  'geopoint': GeoPoint(c.lat, c.lng),
  if (c.logoUrl != null) 'logoUrl': c.logoUrl,
  'photoUrls': c.photoUrls,
  'weeklyHours': c.weeklyHours.map((k, v) => MapEntry(k, v.toMap())),
  'maxCapacity': c.maxCapacity,
  'createdAt': Timestamp.fromDate(c.createdAt),
  'subscriptionType': c.subscriptionType.name,
  'subscriptionExpiresAt': Timestamp.fromDate(c.subscriptionExpiresAt),
  'isActive': c.isActive,
  if (c.phone != null) 'phone': c.phone,
  if (c.email != null) 'email': c.email,
  if (c.website != null) 'website': c.website,
};
