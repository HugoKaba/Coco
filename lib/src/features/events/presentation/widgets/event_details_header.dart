import 'package:flutter/material.dart';
import 'package:coco/src/features/events/domain/models/event_entity.dart';

class EventDetailsHeader extends StatelessWidget {
  final EventEntity event;
  final bool isCreator;
  final VoidCallback? onDelete;

  const EventDetailsHeader({
    super.key,
    required this.event,
    this.isCreator = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (event.imageUrl != null)
              Image.network(
                event.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(context),
              )
            else
              _buildPlaceholder(context),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.event,
          size: 64,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
