import 'package:cloud_firestore/cloud_firestore.dart';

class EventEntity {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final String? imageUrl;
  final String sport;
  final DateTime date;
  final String? locationName;
  final double lat;
  final double lng;
  final int maxPlaces;
  final List<String> attendees;
  final DateTime createdAt;

  const EventEntity({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.sport,
    required this.date,
    this.locationName,
    required this.lat,
    required this.lng,
    required this.maxPlaces,
    required this.attendees,
    required this.createdAt,
  });

  EventEntity copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? imageUrl,
    String? sport,
    DateTime? date,
    String? locationName,
    double? lat,
    double? lng,
    int? maxPlaces,
    List<String>? attendees,
    DateTime? createdAt,
  }) {
    return EventEntity(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      sport: sport ?? this.sport,
      date: date ?? this.date,
      locationName: locationName ?? this.locationName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      maxPlaces: maxPlaces ?? this.maxPlaces,
      attendees: attendees ?? this.attendees,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory EventEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventEntity(
      id: doc.id,
      creatorId: data['creatorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      sport: data['sport'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      locationName: data['locationName'],
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      maxPlaces: data['maxPlaces'] ?? 0,
      attendees: List<String>.from(data['attendees'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'sport': sport,
      'date': Timestamp.fromDate(date),
      'locationName': locationName,
      'lat': lat,
      'lng': lng,
      'maxPlaces': maxPlaces,
      'attendees': attendees,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
