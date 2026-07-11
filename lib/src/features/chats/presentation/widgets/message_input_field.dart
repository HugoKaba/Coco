import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    setState(() => _hasText = text.trim().isNotEmpty);
                  },
                  decoration: InputDecoration(
                    hintText: tr('chats.type_message'),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: _hasText ? _handleSend : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _hasText
                      ? AppColors.brand
                      : cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: _hasText ? Colors.white : cs.onSurfaceVariant,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
