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
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: Theme.of(s.context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
                style: TextStyle(
                  color: Theme.of(s.context).colorScheme.onSurface,
                  fontSize: AppFontSize.xxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    savings != null ? '-$savings%' : 'Populaire',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.xs,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '€${price.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Theme.of(s.context).colorScheme.onSurface,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                period,
                style: TextStyle(
                  fontSize: AppFontSize.lg,
                  color: Theme.of(s.context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _feature(s.context, 'Créneaux illimités'),
          _feature(s.context, 'Accès chat participants'),
          _feature(s.context, 'Statistiques en temps réel'),
        ],
      ),
    ),
  );
}

Widget _feature(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Row(
    children: [
      const Icon(Icons.check_circle, color: AppColors.success, size: 20),
      const SizedBox(width: AppSpacing.md),
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: AppFontSize.sm,
        ),
      ),
    ],
  ),
);
