import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';

class EventSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;

  const EventSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.label = 'events.create_button',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(tr(label) == label ? label : tr(label)),
    );
  }
}
