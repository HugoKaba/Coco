import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class DataSeeder {
  static const String _projectId = 'sportlinker-kuba-studio';
  static const String _baseUrl =
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  final List<String> _firstNames = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Emma",
    "Frank",
    "Grace",
    "Hugo",
    "Ivy",
    "Jack",
    "Kevin",
    "Lea",
    "Mael",
    "Nina",
    "Oscar",
    "Pauline",
    "Quentin",
    "Rose",
    "Simon",
    "Tom",
    "Lucie",
    "Marc",
    "Sophie",
    "Pierre",
    "Julie",
    "Antoine",
    "Camille",
    "Lucas",
    "Marie",
    "Thomas",
    "Laura",
    "Nicolas",
    "Chloe",
    "Alexandre",
    "Manon",
    "Julien",
    "Sarah",
    "Maxime",
    "Lisa",
    "Romain",
    "Clara",
    "Vincent",
    "Elise",
    "Mathieu",
    "Charlotte",
    "Florian",
    "Amelie",
    "Benjamin",
    "Oceane",
    "Theo",
  ];

  final List<String> _lastNames = [
    "Martin",
    "Dupont",
    "Durand",
    "Leroy",
    "Petit",
    "Moreau",
    "Fournier",
    "Girard",
    "Bonnet",
    "Rousseau",
    "Blanc",
    "Garnier",
    "Faure",
    "Roux",
    "Mercier",
    "Guerin",
    "Boyer",
    "Bertrand",
    "Richard",
    "Robert",
    "Lefebvre",
    "Morel",
    "Simon",
    "Laurent",
    "Michel",
    "Garcia",
    "David",
    "Bertrand",
    "Roux",
    "Vincent",
  ];

  final List<Map<String, dynamic>> _citiesIdf = [
    {"name": "Paris", "lat": 48.8566, "lng": 2.3522, "zip": "75001"},
    {"name": "Versailles", "lat": 48.8048, "lng": 2.1204, "zip": "78000"},
    {"name": "Saint-Denis", "lat": 48.9362, "lng": 2.3574, "zip": "93200"},
    {"name": "Créteil", "lat": 48.7904, "lng": 2.4556, "zip": "94000"},
    {
      "name": "Boulogne-Billancourt",
      "lat": 48.8397,
      "lng": 2.2399,
      "zip": "92100",
    },
    {"name": "Nanterre", "lat": 48.8924, "lng": 2.2071, "zip": "92000"},
    {"name": "Cergy", "lat": 49.0389, "lng": 2.0776, "zip": "95000"},
    {"name": "Évry", "lat": 48.6298, "lng": 2.4418, "zip": "91000"},
    {"name": "Melun", "lat": 48.5397, "lng": 2.6607, "zip": "77000"},
    {"name": "Meaux", "lat": 48.9566, "lng": 2.8765, "zip": "77100"},
    {"name": "Chelles", "lat": 48.8797, "lng": 2.5928, "zip": "77500"},
    {
      "name": "Neuilly-sur-Seine",
      "lat": 48.8846,
      "lng": 2.2688,
      "zip": "92200",
    },
    {"name": "Antony", "lat": 48.7538, "lng": 2.2975, "zip": "92160"},
    {"name": "Sarcelles", "lat": 48.9956, "lng": 2.3808, "zip": "95200"},
    {"name": "Clichy", "lat": 48.9044, "lng": 2.3064, "zip": "92110"},
    {"name": "Ivry-sur-Seine", "lat": 48.8116, "lng": 2.3874, "zip": "94200"},
    {"name": "Villejuif", "lat": 48.7933, "lng": 2.3644, "zip": "94800"},
    {"name": "Maisons-Alfort", "lat": 48.8053, "lng": 2.4383, "zip": "94700"},
    {
      "name": "Fontenay-sous-Bois",
      "lat": 48.8514,
      "lng": 2.4772,
      "zip": "94120",
    },
    {"name": "Pantin", "lat": 48.8966, "lng": 2.4017, "zip": "93500"},
  ];

  final List<String> _sportsList = [
    "Football",
    "Tennis",
    "Padel",
    "Running",
    "Basketball",
    "Volleyball",
    "Natation",
    "Cyclisme",
  ];

  final List<String> _levels = [
    "Débutant",
    "Intermédiaire",
    "Confirmé",
    "Expert",
  ];

  final List<String> _days = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche",
  ];

  Future<void> seedUsers() async {
    final httpClient = HttpClient();
    final random = Random();
    int count = 0;

    debugPrint('🌱 Seeding 50 users via REST API...');

    try {
      for (int i = 0; i < 50; i++) {
        final city = _citiesIdf[random.nextInt(_citiesIdf.length)];

        final latOffset = (random.nextDouble() - 0.5) * 0.04;
        final lngOffset = (random.nextDouble() - 0.5) * 0.04;
        final lat = (city["lat"] as double) + latOffset;
        final lng = (city["lng"] as double) + lngOffset;

        final geopoint = GeoPoint(lat, lng);
        final geohash = GeoFirePoint(geopoint).geohash;

        final sports = _getRandomSubset(
          _sportsList,
          random.nextInt(4) + 1,
          random,
        );
        final availabilities = _getRandomSubset(
          _days,
          random.nextInt(4) + 1,
          random,
        );

        final docId = 'test_user_$i';
        final url = Uri.parse('$_baseUrl/users_test?documentId=$docId');

        final sportsValue = sports.map((s) {
          final level = _levels[random.nextInt(_levels.length)];
          return {
            "mapValue": {
              "fields": {
                "sportName": {"stringValue": s},
                "level": {"stringValue": level},
              },
            },
          };
        }).toList();

        final body = jsonEncode({
          "fields": {
            "nom": {
              "stringValue": _lastNames[random.nextInt(_lastNames.length)],
            },
            "prenom": {
              "stringValue": _firstNames[random.nextInt(_firstNames.length)],
            },
            "username": {"stringValue": "user_$i"},
            "email": {"stringValue": "user$i@example.com"},

            "genre": {"stringValue": random.nextBool() ? "Homme" : "Femme"},
            "age": {"integerValue": (random.nextInt(38) + 18).toString()},
            "frequency": {"integerValue": (random.nextInt(5) + 1).toString()},
            "objective": {"stringValue": "Loisir"},
            "description": {"stringValue": "Passionné de sport !"},

            "city": {"stringValue": city["name"]},
            "zipCode": {"stringValue": city["zip"]},
            "latitude": {"doubleValue": lat},
            "longitude": {"doubleValue": lng},
            "geohash": {"stringValue": geohash},

            "userSports": {
              "arrayValue": {"values": sportsValue},
            },

            "jours": {
              "arrayValue": {
                "values": availabilities
                    .map((a) => {"stringValue": a})
                    .toList(),
              },
            },

            "createdAt": {
              "timestampValue": DateTime.now().toUtc().toIso8601String(),
            },
          },
        });

        final request = await httpClient.postUrl(url);
        request.headers.contentType = ContentType.json;
        request.write(body);
        final response = await request.close();

        if (response.statusCode == 200 || response.statusCode == 409) {
          if (response.statusCode == 409) {
            final patchUrl = Uri.parse('$_baseUrl/users_test/$docId');
            final patchReq = await httpClient.patchUrl(patchUrl);
            patchReq.headers.contentType = ContentType.json;
            patchReq.write(body);
            await patchReq.close();
          }
          count++;
        } else {
          final respBody = await utf8.decoder.bind(response).join();
          debugPrint(
            '❌ Failed to seed user $i: ${response.statusCode} $respBody',
          );
        }
      }

      debugPrint('✅ REST Seeding complete! Created/Updated $count users.');
    } catch (e) {
      debugPrint('❌ REST Seeding Error: $e');
      rethrow;
    } finally {
      httpClient.close();
    }
  }

  Future<void> seedEvents() async {
    final httpClient = HttpClient();
    final random = Random();
    int count = 0;

    debugPrint('🎉 Seeding 10 events via REST API...');

    try {
      for (int i = 0; i < 10; i++) {
        final city = _citiesIdf[random.nextInt(_citiesIdf.length)];
        final sport = _sportsList[random.nextInt(_sportsList.length)];
        final maxPlaces = random.nextInt(20) + 5;
        final docId = 'test_event_$i';
        final url = Uri.parse('$_baseUrl/events?documentId=$docId');

        final date = DateTime.now().add(
          Duration(days: random.nextInt(30), hours: random.nextInt(10)),
        );
        final creatorId = 'test_user_${random.nextInt(10)}';

        final body = jsonEncode({
          "fields": {
            "creatorId": {"stringValue": creatorId},
            "title": {"stringValue": "$sport à ${city['name']}"},
            "description": {
              "stringValue": "Venez nombreux pour un match de folie !",
            },
            "sport": {"stringValue": sport},
            "date": {"timestampValue": date.toUtc().toIso8601String()},
            "locationName": {"stringValue": city['name']},
            "lat": {"doubleValue": city['lat']},
            "lng": {"doubleValue": city['lng']},
            "maxPlaces": {"integerValue": maxPlaces.toString()},
            "attendees": {
              "arrayValue": {
                "values": [
                  {"stringValue": creatorId},
                ],
              },
            },
            "createdAt": {
              "timestampValue": DateTime.now().toUtc().toIso8601String(),
            },
            "imageUrl": {
              "stringValue":
                  "https://source.unsplash.com/800x600/?${sport.toLowerCase()}",
            },
          },
        });

        final request = await httpClient.postUrl(url);
        request.headers.contentType = ContentType.json;
        request.write(body);
        final response = await request.close();

        if (response.statusCode == 200 || response.statusCode == 409) {
          if (response.statusCode == 409) {
            final patchUrl = Uri.parse('$_baseUrl/events/$docId');
            final patchReq = await httpClient.patchUrl(patchUrl);
            patchReq.headers.contentType = ContentType.json;
            patchReq.write(body);
            await patchReq.close();
          }
          count++;
        } else {
          final respBody = await utf8.decoder.bind(response).join();
          debugPrint(
            '❌ Failed to seed event $i: ${response.statusCode} $respBody',
          );
        }
      }
      debugPrint(
        '✅ REST Event Seeding complete! Created/Updated $count events.',
      );
    } catch (e) {
      debugPrint('❌ REST Event Seeding Error: $e');
      rethrow;
    } finally {
      httpClient.close();
    }
  }

  List<T> _getRandomSubset<T>(List<T> list, int count, Random random) {
    final shuffled = List<T>.from(list)..shuffle(random);
    return shuffled.take(count).toList();
  }
}
