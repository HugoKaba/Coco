import 'package:flutter/material.dart';

class EventSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;

  const EventSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.label = 'Créer l\'événement',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(label),
    );
  }
}
