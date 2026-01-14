import 'package:flutter/material.dart';
import '../../domain/models/event_entity.dart';

class EventDetailsHeader extends StatelessWidget {
  final EventEntity event;

  const EventDetailsHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(event.title, textScaler: const TextScaler.linear(1.0)),
        background: event.imageUrl != null
            ? Image.network(event.imageUrl!, fit: BoxFit.cover)
            : Container(color: Colors.grey.shade300),
      ),
    );
  }
}
