import 'package:flutter/material.dart';

class EventJoinButton extends StatelessWidget {
  final bool isJoined;
  final bool isFull;
  final VoidCallback? onPressed;

  const EventJoinButton({
    super.key,
    required this.isJoined,
    required this.isFull,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isJoined
              ? Colors.red.shade100
              : Theme.of(context).primaryColor,
          foregroundColor: isJoined ? Colors.red : Colors.white,
        ),
        child: Text(
          isJoined
              ? 'Quitter l\'événement'
              : (isFull ? 'Complet' : 'Rejoindre'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
