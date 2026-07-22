import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/shared/widgets/app_text_field.dart';
import 'package:coco/src/features/auth/widget/input_label.dart';

import 'club_creation_style.dart';

class ClubCreationAccountStep extends StatelessWidget {
  const ClubCreationAccountStep({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final shadow = ClubCreationStyle.inputInnerShadow(context);
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'clubs.create.account_title'.tr(),
            style: TextStyle(
              fontSize: AppFontSize.xxxl,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'clubs.create.account_subtitle'.tr(),
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: AppFontSize.sm),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          InputLabel(label: 'common.email'.tr()),
          AppTextField(
            controller: emailController,
            hintText: 'clubs.create.email_hint'.tr(),
            keyboardType: TextInputType.emailAddress,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: 'common.password'.tr()),
          AppTextField(
            controller: passwordController,
            hintText: 'clubs.create.password_hint'.tr(),
            obscureText: true,
            fieldColor: ClubCreationStyle.field(context),
            borderColor: shadow,
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: ClubCreationStyle.field(context),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: ClubCreationStyle.accent,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'clubs.create.account_info'.tr(),
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
