import 'package:flutter/material.dart';
import 'package:coco/src/features/auth/widget/dark_text_field.dart';
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compte Professionnel',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre compte pour gérer votre club',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 32),
          const InputLabel(label: 'Email'),
          DarkTextField(
            controller: emailController,
            hintText: 'votre@email.com',
            keyboardType: TextInputType.emailAddress,
            fieldColor: ClubCreationStyle.field(context),
            innerShadow: shadow,
          ),
          const SizedBox(height: 20),
          const InputLabel(label: 'Mot de passe'),
          DarkTextField(
            controller: passwordController,
            hintText: 'Minimum 6 caractères',
            obscureText: true,
            fieldColor: ClubCreationStyle.field(context),
            innerShadow: shadow,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ClubCreationStyle.field(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: ClubCreationStyle.accent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vous pourrez vous reconnecter avec ces identifiants',
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
