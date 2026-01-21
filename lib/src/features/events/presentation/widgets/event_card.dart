import 'package:flutter/material.dart';

import 'package:coco/src/features/events/domain/models/event_entity.dart';
import 'package:coco/src/features/events/presentation/widgets/event_card_image.dart';
import 'package:easy_localization/easy_localization.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventCardImage(imageUrl: event.imageUrl),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, dateFormat),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateFormat fmt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            event.sport.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          fmt.format(event.date),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          event.locationName ?? tr('events.location_unknown'),
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Icon(Icons.group_rounded, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          '${event.attendees.length} / ${event.maxPlaces}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
