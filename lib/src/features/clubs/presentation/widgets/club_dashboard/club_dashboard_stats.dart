import 'package:flutter/material.dart';
import 'package:coco/src/features/clubs/domain/models/slot_entity.dart';

class ClubDashboardStats extends StatelessWidget {
  const ClubDashboardStats({super.key, required this.slots});

  final List<SlotEntity> slots;

  @override
  Widget build(BuildContext context) {
    final bookedCount = slots.fold<int>(
      0,
      (sum, slot) => sum + slot.participants.length,
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _card('Total Créneaux', '${slots.length}')),
          const SizedBox(width: 16),
          Expanded(child: _card('Participants', '$bookedCount')),
        ],
      ),
    );
  }

  Widget _card(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
