import 'package:easy_localization/easy_localization.dart';
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
    required this.facilities,
    required this.city,
    required this.address,
    required this.phone,
    required this.subscriptionType,
  });

  final String email;
  final String clubName;
  final List<String> activities;
  final String facilities;
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
            'clubs.create.review_title'.tr(),
            style: TextStyle(
              fontSize: AppFontSize.xxxl,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _section(context, 'clubs.create.section_account'.tr(), [
            _item(context, 'common.email'.tr(), email),
            _item(context, 'common.password'.tr(), '••••••••'),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'clubs.create.section_club'.tr(), [
            _item(context, 'clubs.create.field_name'.tr(), clubName),
            _item(
              context,
              'clubs.create.field_activities'.tr(),
              ClubSportCatalog.labelsTextFor(activities),
            ),
            if (facilities.trim().isNotEmpty)
              _item(context, 'clubs.create.field_facilities'.tr(), facilities),
            _item(context, 'clubs.create.field_city'.tr(), city),
            _item(context, 'clubs.create.field_address'.tr(), address),
            if (phone.isNotEmpty)
              _item(context, 'clubs.create.field_phone'.tr(), phone),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'clubs.create.section_subscription'.tr(), [
            _item(
              context,
              'clubs.create.field_plan'.tr(),
              subscriptionType == SubscriptionType.monthly
                  ? 'clubs.subscription.monthly'.tr()
                  : 'clubs.subscription.annual'.tr(),
            ),
            _item(
              context,
              'clubs.create.field_price'.tr(),
              subscriptionType == SubscriptionType.monthly
                  ? 'clubs.subscription.price_monthly'.tr()
                  : 'clubs.subscription.price_annual'.tr(),
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
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: AppFontSize.sm,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'common.not_provided'.tr() : value,
              style: TextStyle(color: cs.onSurface, fontSize: AppFontSize.sm),
            ),
          ),
        ],
      ),
    );
  }
}
