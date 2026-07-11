import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';

class EventFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;
  final String selectedSport;
  final List<String> sports;
  final Function(String?) onSportChanged;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function() onDatePick;
  final Function() onTimePick;

  const EventFormFields({
    super.key,
    required this.titleController,
    required this.locationController,
    required this.descriptionController,
    required this.selectedSport,
    required this.sports,
    required this.onSportChanged,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDatePick,
    required this.onTimePick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: tr('events.event_title'),
            border: const OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? tr('common.error') : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<String>(
          initialValue: selectedSport,
          decoration: InputDecoration(
            labelText: tr('filters.sports'),
            border: const OutlineInputBorder(),
          ),
          items: sports
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: onSportChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                onPressed: onDatePick,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(selectedTime.format(context)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
                onPressed: onTimePick,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: tr('events.location'),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on),
          ),
          validator: (v) => v == null || v.isEmpty ? tr('common.error') : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: tr('events.description'),
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? tr('common.error') : null,
        ),
      ],
    );
  }
}
