import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/features/events/domain/models/event_entity.dart';
import 'package:coco/src/features/events/presentation/controllers/create_event_controller.dart';
import 'package:coco/src/features/events/presentation/widgets/create_event_form_body.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  final EventEntity? eventToEdit;

  const CreateEventScreen({super.key, this.eventToEdit});
  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _uploadedImageUrl;
  String _selectedSport = 'Football';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  int _maxPlaces = 10;

  final List<String> _sports = [
    'Football',
    'Tennis',
    'Padel',
    'Running',
    'Basketball',
    'Volleyball',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      final e = widget.eventToEdit!;
      _titleController.text = e.title;
      _descriptionController.text = e.description;
      _locationController.text = e.locationName ?? '';
      _selectedSport = e.sport;
      _selectedDate = e.date;
      _selectedTime = TimeOfDay.fromDateTime(e.date);
      _maxPlaces = e.maxPlaces;
      _uploadedImageUrl = e.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref
          .read(createEventControllerProvider.notifier)
          .submit(
            eventToEdit: widget.eventToEdit,
            title: _titleController.text,
            description: _descriptionController.text,
            locationName: _locationController.text,
            sport: _selectedSport,
            date: _selectedDate,
            time: _selectedTime,
            maxPlaces: _maxPlaces,
            imageUrl: _uploadedImageUrl,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.eventToEdit != null
                  ? tr('events.update_success')
                  : tr('events.create_success'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr('events.error_generic', namedArgs: {'error': '$e'}))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventToEdit != null;
    final state = ref.watch(createEventControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? tr('events.edit_title') : tr('events.create_title'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 200),
        child: Form(
          key: _formKey,
          child: CreateEventFormBody(
            titleController: _titleController,
            descriptionController: _descriptionController,
            locationController: _locationController,
            selectedSport: _selectedSport,
            selectedDate: _selectedDate,
            selectedTime: _selectedTime,
            maxPlaces: _maxPlaces,
            isLoading: state.isLoading,
            sports: _sports,
            isEditing: isEditing,
            onSubmit: _submit,
            onSportChanged: (v) => setState(() => _selectedSport = v!),
            onDateChanged: (v) => setState(() => _selectedDate = v),
            onTimeChanged: (v) => setState(() => _selectedTime = v),
            onImageUploaded: (v) => setState(() => _uploadedImageUrl = v),
            onPlacesChanged: (v) => setState(() => _maxPlaces = v),
          ),
        ),
      ),
    );
  }
}
