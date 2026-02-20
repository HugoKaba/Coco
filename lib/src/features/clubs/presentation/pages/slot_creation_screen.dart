import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/app_enums.dart';
import '../../application/club_providers.dart';
import '../../domain/models/slot_entity.dart';

part 'slot_creation_screen_form.part.dart';
part 'slot_creation_screen_form_extras.part.dart';
part 'slot_creation_screen_time.part.dart';
part 'slot_creation_screen_submit.part.dart';

class SlotCreationScreen extends ConsumerStatefulWidget {
  const SlotCreationScreen({super.key, required this.clubId});
  final String clubId;

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
  BoxLevel _selectedLevel = BoxLevel.beginner;
  RangeValues _ageRange = const RangeValues(18, 60);
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
            _buildSlotTypeSelector(this),
            const SizedBox(height: 24),
            _buildSlotDateTimePickers(this),
            const SizedBox(height: 24),
            _buildSlotCapacityField(this),
            const SizedBox(height: 24),
            _buildSlotLevelSelector(this),
            const SizedBox(height: 24),
            _buildSlotAgeRangeSelector(this),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _submitSlotForm(this),
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
}
