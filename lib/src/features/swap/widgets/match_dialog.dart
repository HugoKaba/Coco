import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/features/profile/presentation/public_profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../chats/presentation/pages/chat_screen.dart';
import '../../filters/domain/models/person_entity.dart';

part 'match_dialog_actions.part.dart';

class MatchDialog extends StatelessWidget {
  const MatchDialog({super.key, required this.person});
  final PersonEntity person;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppColors.brand,
                size: 60,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                tr('match.title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSize.display,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brand,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brand, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brand.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    person.profilePhotoUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                tr('match.description', args: [person.firstName]),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSize.lg,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _openChat(context, person),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Text(
                    tr('match.send_message'),
                    style: const TextStyle(
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PublicProfileScreen(
                          userId: person.id,
                          cachedPerson: person,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_outline_rounded),
                  label: const Text(
                    'Voir le profil',
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.brand,
                    side: const BorderSide(color: AppColors.brand),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: Text(
                    tr('match.keep_swiping'),
                    style: const TextStyle(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
