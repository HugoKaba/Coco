import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/features/events/presentation/widgets/event_form_fields.dart';
import 'package:coco/src/features/events/presentation/widgets/event_image_picker.dart';
import 'package:coco/src/features/events/presentation/widgets/event_places_slider.dart';
import 'package:coco/src/features/events/presentation/widgets/event_submit_button.dart';

class CreateEventFormBody extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final String selectedSport;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int maxPlaces;
  final bool isLoading;
  final List<String> sports;
  final VoidCallback onSubmit;
  final ValueChanged<String?> onSportChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueChanged<String> onImageUploaded;
  final ValueChanged<int> onPlacesChanged;
  final bool isEditing;

  const CreateEventFormBody({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.selectedSport,
    required this.selectedDate,
    required this.selectedTime,
    required this.maxPlaces,
    required this.isLoading,
    required this.sports,
    required this.onSubmit,
    required this.onSportChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onImageUploaded,
    required this.onPlacesChanged,
    required this.isEditing,
  });

  @override
  State<CreateEventFormBody> createState() => _CreateEventFormBodyState();
}

class _CreateEventFormBodyState extends State<CreateEventFormBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventFormFields(
          titleController: widget.titleController,
          locationController: widget.locationController,
          descriptionController: widget.descriptionController,
          selectedSport: widget.selectedSport,
          sports: widget.sports,
          onSportChanged: (v) => widget.onSportChanged(v!),
          selectedDate: widget.selectedDate,
          selectedTime: widget.selectedTime,
          onDatePick: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: widget.selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (d != null) widget.onDateChanged(d);
          },
          onTimePick: () async {
            final t = await showTimePicker(
              context: context,
              initialTime: widget.selectedTime,
            );
            if (t != null) widget.onTimeChanged(t);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        EventImagePicker(onImageUploaded: widget.onImageUploaded),
        const SizedBox(height: AppSpacing.lg),
        EventPlacesSlider(
          maxPlaces: widget.maxPlaces,
          onChanged: (v) => widget.onPlacesChanged(v.toInt()),
        ),
        const SizedBox(height: AppSpacing.xxl),
        EventSubmitButton(
          isLoading: widget.isLoading,
          onPressed: widget.onSubmit,
          label: widget.isEditing
              ? 'events.save_changes'
              : 'events.create_button',
        ),
      ],
    );
  }
}
