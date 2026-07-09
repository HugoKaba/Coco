import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SportFilterBar extends StatelessWidget {
  final String? selectedSport;
  final Function(String?) onSportSelected;
  final List<String> sports;

  const SportFilterBar({
    super.key,
    required this.selectedSport,
    required this.onSportSelected,
    this.sports = const [
      'Football',
      'Tennis',
      'Padel',
      'Running',
      'Basketball',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildChip(
              context,
              label: tr('events.all'),
              isSelected: selectedSport == null,
              onTap: () => onSportSelected(null),
            );
          }
          final sport = sports[index - 1];
          return _buildChip(
            context,
            label: sport,
            isSelected: selectedSport == sport,
            onTap: () => onSportSelected(sport),
          );
        },
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.2)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? primaryColor : theme.dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              Icon(Icons.check_rounded, size: 16, color: primaryColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? primaryColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
