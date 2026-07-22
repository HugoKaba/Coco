import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coco/src/core/theme/app_text_styles.dart';
import 'package:coco/src/core/theme/app_radius.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/features/clubs/domain/models/club_entity.dart';

class ClubDashboardHeader extends StatelessWidget {
  const ClubDashboardHeader({super.key, required this.club});

  final ClubEntity club;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: AppSpacing.lg),
              Text(
                'clubs.dashboard.title'.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  club.avatarImageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  cacheWidth: 80,
                  errorBuilder: (_, __, ___) => const CircleAvatar(
                    backgroundColor: AppColors.brand,
                    child: Icon(Icons.business, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: TextStyle(
                        fontSize: AppFontSize.xxl,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      club.city,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              _chip(
                context,
                icon: Icons.people,
                label: 'clubs.dashboard.capacity_value'.tr(
                  namedArgs: {'count': '${club.maxCapacity}'},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _chip(
                context,
                icon: Icons.star,
                label: club.subscriptionType.displayName,
                color: AppColors.brand,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final cs = Theme.of(context).colorScheme;
    final bg = color ?? cs.surfaceContainerHighest;
    final fg = color != null ? Colors.white : cs.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: fg, fontSize: AppFontSize.xs),
          ),
        ],
      ),
    );
  }
}
