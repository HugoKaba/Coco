import 'package:flutter/material.dart';

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
  static const _accent = Color(0xFFCD8232);
  SubscriptionType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisissez votre formule'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _planCard(
                      this,
                      type: SubscriptionType.monthly,
                      price: 29.99,
                      period: '/mois',
                      isPopular: false,
                    ),
                    const SizedBox(height: 20),
                    _planCard(
                      this,
                      type: SubscriptionType.annual,
                      price: 299.99,
                      period: '/an',
                      isPopular: true,
                      savings: 17,
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedType != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () =>
                        widget.onSubscriptionSelected(_selectedType!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 18,
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
