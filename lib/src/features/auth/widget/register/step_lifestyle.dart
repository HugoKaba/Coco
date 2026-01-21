import 'package:flutter/material.dart';
import '../dark_text_field.dart';
import '../preference_row.dart';

class StepLifestyle extends StatelessWidget {
  final TextEditingController bioController;
  final TextEditingController sportCategoryController;
  final TextEditingController activityFrequencyController;
  final String dailyPreference;
  final ValueChanged<String> onPreferenceSelected;
  final Color accentColor;
  final Color fieldColor;
  final Color innerShadow;

  const StepLifestyle({
    super.key,
    required this.bioController,
    required this.sportCategoryController,
    required this.activityFrequencyController,
    required this.dailyPreference,
    required this.onPreferenceSelected,
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
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text("Description",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500
              )
          ),
          const SizedBox(height: 8),
          DarkTextField(controller: bioController, maxLines: 3, fieldColor: fieldColor, innerShadow: innerShadow),
          const SizedBox(height: 22),
          Text("Catégorie de sport", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DarkTextField(controller: sportCategoryController, fieldColor: fieldColor, innerShadow: innerShadow),
          const SizedBox(height: 22),
          Text("Fréquence d'activité", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DarkTextField(controller: activityFrequencyController, fieldColor: fieldColor, innerShadow: innerShadow),
          const SizedBox(height: 22),
          Text("Préférence journalière", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          PreferenceRow(selectedPreference: dailyPreference, onTap: onPreferenceSelected, accentColor: accentColor),
        ],
      ),
    );
  }
}
