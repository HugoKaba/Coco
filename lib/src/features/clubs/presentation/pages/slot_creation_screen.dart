import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/models/slot_entity.dart';
import '../../application/club_providers.dart';
import '../../../../core/domain/app_enums.dart';

class SlotCreationScreen extends ConsumerStatefulWidget {
  final String clubId;

  const SlotCreationScreen({super.key, required this.clubId});

  @override
  ConsumerState<SlotCreationScreen> createState() => _SlotCreationScreenState();
}

class _SlotCreationScreenState extends ConsumerState<SlotCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  static const Color _accentColor = Color(0xFFCD8232);
  static const Color _bgColor = Color(0xFF121212);
  static const Color _cardColor = Color(0xFF1F1F1F);

  SlotType _type = SlotType.course;
  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 2));

  int _maxParticipants = 12;
  int? _courtNumber;

  // New fields
  BoxLevel _selectedLevel = BoxLevel.beginner;
  RangeValues _ageRange = const RangeValues(18, 60);

  // ... existing fields ...
  final bool _isRecurring = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text('clubs.slot.create'.tr()),
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewPadding.bottom + 120,
          ),
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 24),
            _buildDateTimePickers(),
            const SizedBox(height: 24),
            _buildCapacityField(),
            const SizedBox(height: 24),
            _buildLevelSelector(),
            const SizedBox(height: 24),
            _buildAgeRangeSelector(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'clubs.slot.create'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: SlotType.values.map((type) {
          final isSelected = _type == type;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _type = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? _accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      children: [
        _buildDateTimePicker(
          label: 'clubs.slot.start_time'.tr(),
          date: _startTime,
          onTap: _pickStartTime,
        ),
        const SizedBox(height: 16),
        _buildDateTimePicker(
          label: 'clubs.slot.end_time'.tr(),
          date: _endTime,
          onTap: _pickEndTime,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calendar_today, color: _accentColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEE, MMM dd • HH:mm').format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            'clubs.slot.capacity'.tr(),
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCapacityButton(
                icon: Icons.remove,
                onTap: () => setState(() {
                  if (_maxParticipants > 1) _maxParticipants--;
                }),
              ),
              const SizedBox(width: 32),
              Text(
                '$_maxParticipants',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 32),
              _buildCapacityButton(
                icon: Icons.add,
                onTap: () => setState(() => _maxParticipants++),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'clubs.slot.level'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: BoxLevel.values.map((level) {
            final isSelected = _selectedLevel == level;
            return FilterChip(
              label: Text(level.translationKey.tr()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedLevel = level);
              },
              backgroundColor: _cardColor,
              selectedColor: _accentColor,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? _accentColor : Colors.white10,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'clubs.slot.age_group'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_ageRange.start.round()} - ${_ageRange.end.round()} ans',
              style: const TextStyle(
                color: _accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: RangeSlider(
            values: _ageRange,
            min: 5,
            max: 90,
            divisions: 85,
            activeColor: _accentColor,
            inactiveColor: Colors.white10,
            labels: RangeLabels(
              _ageRange.start.round().toString(),
              _ageRange.end.round().toString(),
            ),
            onChanged: (values) => setState(() => _ageRange = values),
          ),
        ),
      ],
    );
  }

  Future<void> _pickStartTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: _themeBuilder,
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
      builder: _themeBuilder,
    );
    if (time == null) return;

    setState(() {
      _startTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      if (_startTime.isAfter(_endTime)) {
        _endTime = _startTime.add(const Duration(hours: 1));
      }
    });
  }

  Future<void> _pickEndTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: _startTime,
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: _themeBuilder,
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endTime),
      builder: _themeBuilder,
    );
    if (time == null) return;

    setState(() {
      _endTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Widget _themeBuilder(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: _accentColor,
          surface: _cardColor,
          onSurface: Colors.white,
        ),
        dialogTheme: DialogThemeData(backgroundColor: _bgColor),
      ),
      child: child!,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final slot = SlotEntity(
        id: '',
        clubId: widget.clubId,
        type: _type,
        startTime: _startTime,
        endTime: _endTime,
        maxParticipants: _maxParticipants,
        participants: [],
        level: _selectedLevel.name, // Storing enum name
        ageGroup:
            '${_ageRange.start.round()}-${_ageRange.end.round()}', // Storing range as string
        courtNumber: _courtNumber,
        isRecurring: _isRecurring,
        createdAt: DateTime.now(),
      );

      final slotRepo = ref.read(slotRepositoryProvider);
      await slotRepo.createSlot(slot);

      if (mounted) {
        ref.invalidate(upcomingSlotsProvider(widget.clubId));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('clubs.slot.created_success'.tr()),
            backgroundColor: _accentColor,
          ),
        );
      }
    }
  }
}
