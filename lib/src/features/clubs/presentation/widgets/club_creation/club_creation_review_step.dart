import 'package:flutter/material.dart';
import 'package:coco/src/features/clubs/domain/models/subscription_tier.dart';

import 'club_creation_style.dart';

class ClubCreationReviewStep extends StatelessWidget {
  const ClubCreationReviewStep({
    super.key,
    required this.email,
    required this.clubName,
    required this.sportType,
    required this.city,
    required this.address,
    required this.phone,
    required this.subscriptionType,
  });

  final String email;
  final String clubName;
  final String sportType;
  final String city;
  final String address;
  final String phone;
  final SubscriptionType subscriptionType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vérification',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _section('Compte', [
            _item('Email', email),
            _item('Mot de passe', '••••••••'),
          ]),
          const SizedBox(height: 16),
          _section('Club', [
            _item('Nom', clubName),
            _item('Sport', sportType),
            _item('Ville', city),
            _item('Adresse', address),
            if (phone.isNotEmpty) _item('Téléphone', phone),
          ]),
          const SizedBox(height: 16),
          _section('Abonnement', [
            _item(
              'Formule',
              subscriptionType == SubscriptionType.monthly
                  ? 'Mensuel'
                  : 'Annuel',
            ),
            _item(
              'Prix',
              subscriptionType == SubscriptionType.monthly
                  ? '29.99€/mois'
                  : '299.99€/an',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClubCreationStyle.field,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ClubCreationStyle.accent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Non renseigné' : value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
