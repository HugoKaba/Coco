import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';

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
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          backgroundColor: isJoined
              ? Colors.red.shade100
              : Theme.of(context).primaryColor,
          foregroundColor: isJoined ? Colors.red : Colors.white,
        ),
        child: Text(
          isJoined
              ? 'events.leave'.tr()
              : (isFull ? 'events.full'.tr() : 'events.join'.tr()),
          style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
