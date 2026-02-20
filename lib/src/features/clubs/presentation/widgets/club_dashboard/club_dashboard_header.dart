import 'package:flutter/material.dart';
import 'package:coco/src/features/clubs/domain/models/club_entity.dart';

class ClubDashboardHeader extends StatelessWidget {
  const ClubDashboardHeader({super.key, required this.club});

  final ClubEntity club;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Tableau de bord',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (club.logoUrl != null)
                CircleAvatar(backgroundImage: NetworkImage(club.logoUrl!))
              else
                const CircleAvatar(
                  backgroundColor: Color(0xFFCD8232),
                  child: Icon(Icons.business, color: Colors.white),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      club.city,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _chip(icon: Icons.people, label: 'Capacité: ${club.maxCapacity}'),
              const SizedBox(width: 12),
              _chip(
                icon: Icons.star,
                label: club.subscriptionType.displayName,
                color: const Color(0xFFCD8232),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    Color color = const Color(0xFF2C2C2C),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
