import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/club_providers.dart';

/// Bouton d'adhésion à une asso.
///
/// Gère lui-même l'état "membre / pas membre" (via [isMemberProvider]) et
/// l'état de chargement local pendant l'appel réseau, pour éviter les
/// double-clics et donner un retour visuel à l'utilisateur.
class ClubMembershipButton extends ConsumerStatefulWidget {
  const ClubMembershipButton({super.key, required this.clubId});

  final String clubId;

  @override
  ConsumerState<ClubMembershipButton> createState() =>
      _ClubMembershipButtonState();
}

class _ClubMembershipButtonState extends ConsumerState<ClubMembershipButton> {
  bool _busy = false;

  Future<void> _toggleMembership(bool isMember) async {
    // Si on quitte, on demande confirmation d'abord.
    if (isMember) {
      final confirmed = await _confirmLeave();
      if (confirmed != true) return;
    }

    setState(() => _busy = true);
    try {
      final service = ref.read(clubMembershipServiceProvider);
      if (isMember) {
        await service.leaveClub(widget.clubId);
      } else {
        await service.joinClub(widget.clubId);
      }
      // Rafraîchit l'état d'adhésion pour recalculer le bouton.
      ref.invalidate(isMemberProvider(widget.clubId));
      if (!mounted) return;
      _showSnackBar(
        isMember ? 'clubs.leave_success'.tr() : 'clubs.join_success'.tr(),
      );
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('clubs.membership_error'.tr());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmLeave() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('clubs.leave_confirm_title'.tr()),
        content: Text('clubs.leave_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('clubs.leave_club'.tr()),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isMemberAsync = ref.watch(isMemberProvider(widget.clubId));

    return isMemberAsync.when(
      data: (isMember) => AppButton(
        label: isMember ? 'clubs.member_active'.tr() : 'clubs.join'.tr(),
        icon: isMember ? Icons.check_circle : Icons.add_circle_outline,
        isLoading: _busy,
        color: isMember ? AppColors.success : null,
        onPressed: () => _toggleMembership(isMember),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Text('common.error'.tr()),
    );
  }
}
