import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';

import '../../domain/models/subscription_tier.dart';

part 'subscription_selection_screen_cards.part.dart';

class SubscriptionSelectionScreen extends StatefulWidget {
  const SubscriptionSelectionScreen({
    super.key,
    required this.onSubscriptionSelected,
  });
  final Function(SubscriptionType) onSubscriptionSelected;

  @override
  State<SubscriptionSelectionScreen> createState() =>
      _SubscriptionSelectionScreenState();
}

class _SubscriptionSelectionScreenState
    extends State<SubscriptionSelectionScreen> {
  static const _accent = AppColors.brand;
  SubscriptionType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('clubs.subscription.title'.tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _planCard(
                      this,
                      type: SubscriptionType.monthly,
                      price: 29.99,
                      period: 'clubs.subscription.per_month'.tr(),
                      isPopular: false,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _planCard(
                      this,
                      type: SubscriptionType.annual,
                      price: 299.99,
                      period: 'clubs.subscription.per_year'.tr(),
                      isPopular: true,
                      savings: 17,
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedType != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () =>
                        widget.onSubscriptionSelected(_selectedType!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                    ),
                    child: Text(
                      'common.continue'.tr(),
                      style: const TextStyle(
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
