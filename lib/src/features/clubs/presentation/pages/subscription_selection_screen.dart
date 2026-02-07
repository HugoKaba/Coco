import 'package:flutter/material.dart';
import '../../domain/models/subscription_tier.dart';

class SubscriptionSelectionScreen extends StatefulWidget {
  final Function(SubscriptionType) onSubscriptionSelected;

  const SubscriptionSelectionScreen({
    super.key,
    required this.onSubscriptionSelected,
  });

  @override
  State<SubscriptionSelectionScreen> createState() =>
      _SubscriptionSelectionScreenState();
}

class _SubscriptionSelectionScreenState
    extends State<SubscriptionSelectionScreen> {
  SubscriptionType? _selectedType;

  static const Color _accentColor = Color(0xFFCD8232);
  static const Color _bgColor = Color(0xFF121212);
  static const Color _fieldColor = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        title: const Text('Choisissez votre formule'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlanCard(
                      type: SubscriptionType.monthly,
                      price: 29.99,
                      period: '/mois',
                      isPopular: false,
                    ),
                    const SizedBox(height: 20),
                    _buildPlanCard(
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
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () =>
                        widget.onSubscriptionSelected(_selectedType!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
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

  Widget _buildPlanCard({
    required SubscriptionType type,
    required double price,
    required String period,
    required bool isPopular,
    int? savings,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _fieldColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _accentColor : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type == SubscriptionType.monthly ? 'Mensuel' : 'Annuel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      savings != null ? '-$savings%' : 'Populaire',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '€${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  period,
                  style: const TextStyle(fontSize: 18, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeature('Créneaux illimités'),
            _buildFeature('Accès chat participants'),
            _buildFeature('Statistiques en temps réel'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
