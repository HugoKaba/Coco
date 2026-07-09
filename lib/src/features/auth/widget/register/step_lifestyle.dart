import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../dark_text_field.dart';
import 'sports_selection_widget.dart';
import 'frequency_selector.dart';
import 'days_selector.dart';

class StepLifestyle extends StatelessWidget {
  final TextEditingController bioController;
  final List<Map<String, dynamic>> selectedSports;
  final ValueChanged<List<Map<String, dynamic>>> onSportsChanged;
  final int frequency;
  final ValueChanged<int> onFrequencyChanged;
  final List<int> selectedDays;
  final ValueChanged<List<int>> onDaysChanged;
  final Color accentColor;
  final Color fieldColor;
  final Color innerShadow;

  const StepLifestyle({
    super.key,
    required this.bioController,
    required this.selectedSports,
    required this.onSportsChanged,
    required this.frequency,
    required this.onFrequencyChanged,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.accentColor,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            tr('register.description'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DarkTextField(
            controller: bioController,
            maxLines: 3,
            hintText: tr('register.about_me'),
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: 16),
          Text(
            tr('register.sport_category'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SportsSelectionWidget(
            selectedSports: selectedSports,
            onChanged: onSportsChanged,
          ),
          const SizedBox(height: 16),
          Text(
            tr('register.activity_frequency'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          FrequencySelector(
            frequency: frequency,
            onChanged: onFrequencyChanged,
            accentColor: accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            tr('register.daily_preference'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DaysSelector(
            selectedDays: selectedDays,
            onChanged: onDaysChanged,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}
