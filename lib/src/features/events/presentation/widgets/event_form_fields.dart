import 'package:flutter/material.dart';

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
          decoration: const InputDecoration(
            labelText: 'Titre',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedSport,
          decoration: const InputDecoration(
            labelText: 'Sport',
            border: OutlineInputBorder(),
          ),
          items: sports
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: onSportChanged,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                onPressed: onDatePick,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(selectedTime.format(context)),
                onPressed: onTimePick,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: 'Lieu',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
        ),
      ],
    );
  }
}
