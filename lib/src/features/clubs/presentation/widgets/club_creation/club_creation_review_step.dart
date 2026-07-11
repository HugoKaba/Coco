import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/features/clubs/domain/models/subscription_tier.dart';
import 'package:coco/src/features/clubs/domain/models/club_sport_catalog.dart';

import 'club_creation_style.dart';

class ClubCreationReviewStep extends StatelessWidget {
  const ClubCreationReviewStep({
    super.key,
    required this.email,
    required this.clubName,
    required this.activities,
    required this.city,
    required this.address,
    required this.phone,
    required this.subscriptionType,
  });

  final String email;
  final String clubName;
  final List<String> activities;
  final String city;
  final String address;
  final String phone;
  final SubscriptionType subscriptionType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vérification',
            style: TextStyle(
              fontSize: AppFontSize.xxxl,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _section(context, 'Compte', [
            _item(context, 'Email', email),
            _item(context, 'Mot de passe', '••••••••'),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'Club', [
            _item(context, 'Nom', clubName),
            _item(
              context,
              'Activités',
              ClubSportCatalog.labelsTextFor(activities),
            ),
            _item(context, 'Ville', city),
            _item(context, 'Adresse', address),
            if (phone.isNotEmpty) _item(context, 'Téléphone', phone),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'Abonnement', [
            _item(
              context,
              'Formule',
              subscriptionType == SubscriptionType.monthly
                  ? 'Mensuel'
                  : 'Annuel',
            ),
            _item(
              context,
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

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: ClubCreationStyle.field(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ClubCreationStyle.accent,
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: AppFontSize.sm),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Non renseigné' : value,
              style: TextStyle(color: cs.onSurface, fontSize: AppFontSize.sm),
            ),
          ),
        ],
      ),
    );
  }
}
