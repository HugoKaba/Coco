import 'package:coco/src/core/theme/app_colors.dart';
import 'package:coco/src/features/filters/application/firestore_seeder_service.dart';
import 'package:coco/src/features/home/presentation/widgets/app_glass_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Page (dev) regroupant les générateurs de données de démo, sortie de la liste
/// principale du compte pour ne pas l'encombrer. Chaque bouton remplit une
/// collection Firestore ; l'ordre ①→④ compte (dépendances entre données).
class SeederPage extends StatelessWidget {
  const SeederPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('account.seed.title'))),
      body: ListView(
        // Padding bas pour dégager le dernier item de la tabbar flottante.
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8 + kGlassBottomBarClearance,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              tr('account.seed.hint'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          _tile(
            context,
            Icons.people_alt_rounded,
            tr('account.seed.users_label'),
            () => FirestoreSeederService().seedUsers(),
            tr('account.seed.users_running'),
            tr('account.seed.users_done'),
          ),
          _tile(
            context,
            Icons.stadium,
            tr('account.seed.clubs_label'),
            () => FirestoreSeederService().seedClubsAndSlots(),
            tr('account.seed.clubs_running'),
            tr('account.seed.clubs_done'),
          ),
          _tile(
            context,
            Icons.emoji_events,
            tr('account.seed.events_label'),
            () => FirestoreSeederService().seedEvents(),
            tr('account.seed.events_running'),
            tr('account.seed.events_done'),
          ),
          _tile(
            context,
            Icons.forum,
            tr('account.seed.conversations_label'),
            () => FirestoreSeederService().seedConversations(),
            tr('account.seed.conversations_running'),
            tr('account.seed.conversations_done'),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label,
    Future<void> Function() action,
    String running,
    String done,
  ) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: AppColors.brand),
      title: Text(
        label,
        style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: cs.onSurface.withValues(alpha: 0.3),
      ),
      onTap: () => _run(context, action, running, done),
    );
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String start,
    String done,
  ) async {
    // On capture le messenger avant l'await pour éviter d'utiliser un context
    // potentiellement démonté après l'opération asynchrone.
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(content: Text(start)));
    await action();
    messenger.showSnackBar(SnackBar(content: Text(done)));
  }
}
