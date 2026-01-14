// For now, hardcode or assume a test user ID.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers.dart';
import '../../application/events_service.dart';
import '../../domain/models/event_entity.dart';
import '../widgets/event_form_fields.dart';
import '../widgets/event_submit_button.dart';
import '../widgets/event_places_slider.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});
  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedSport = 'Football';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  int _maxPlaces = 10;
  bool _isLoading = false;

  final List<String> _sports = [
    'Football',
    'Tennis',
    'Padel',
    'Running',
    'Basketball',
    'Volleyball',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final date = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final user = ref.read(authStateChangesProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final newEvent = EventEntity(
        id: const Uuid().v4(),
        creatorId: user.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        sport: _selectedSport,
        date: date,
        locationName: _locationController.text,
        lat: 48.8566,
        lng: 2.3522,
        maxPlaces: _maxPlaces,
        attendees: [user.uid],
        createdAt: DateTime.now(),
        imageUrl:
            'https://source.unsplash.com/800x600/?${_selectedSport.toLowerCase()}',
      );

      await ref.read(eventsServiceProvider.notifier).createEvent(newEvent);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement créé avec succès !')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un événement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EventFormFields(
                titleController: _titleController,
                locationController: _locationController,
                descriptionController: _descriptionController,
                selectedSport: _selectedSport,
                sports: _sports,
                onSportChanged: (v) => setState(() => _selectedSport = v!),
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDatePick: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) setState(() => _selectedDate = d);
                },
                onTimePick: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (t != null) setState(() => _selectedTime = t);
                },
              ),
              const SizedBox(height: 16),
              EventPlacesSlider(
                maxPlaces: _maxPlaces,
                onChanged: (v) => setState(() => _maxPlaces = v.toInt()),
              ),
              const SizedBox(height: 24),
              EventSubmitButton(isLoading: _isLoading, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
