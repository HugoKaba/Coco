import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DateFilterSection extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateChanged;

  const DateFilterSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            tr('filters.date'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 31,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final isSelected =
                  selectedDate != null &&
                  selectedDate!.year == normalizedDate.year &&
                  selectedDate!.month == normalizedDate.month &&
                  selectedDate!.day == normalizedDate.day;

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    onDateChanged(null);
                  } else {
                    onDateChanged(normalizedDate);
                  }
                },
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat(
                          'EEE',
                          context.locale.toString(),
                        ).format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
