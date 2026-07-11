import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';

class ConversationEmptyState extends StatelessWidget {
  const ConversationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              tr('chats.no_conversations'),
              style: TextStyle(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              tr('chats.no_conversations_hint'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppFontSize.md, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
