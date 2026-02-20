// ignore_for_file: invalid_use_of_protected_member
part of 'subscription_selection_screen.dart';

Widget _planCard(
  _SubscriptionSelectionScreenState s, {
  required SubscriptionType type,
  required double price,
  required String period,
  required bool isPopular,
  int? savings,
}) {
  final isSelected = s._selectedType == type;
  return GestureDetector(
    onTap: () => s.setState(() => s._selectedType = type),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _SubscriptionSelectionScreenState._field,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? _SubscriptionSelectionScreenState._accent
              : Colors.transparent,
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
          _feature('Créneaux illimités'),
          _feature('Accès chat participants'),
          _feature('Statistiques en temps réel'),
        ],
      ),
    ),
  );
}

Widget _feature(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Row(
    children: [
      const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
      const SizedBox(width: 12),
      Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
    ],
  ),
);
