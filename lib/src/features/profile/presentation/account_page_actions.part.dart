part of 'account_page.dart';

List<Widget> buildAccountActions(BuildContext context, WidgetRef ref) {
  return [
    _item(
      context,
      Icons.settings,
      tr('account.settings'),
      () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
    ),
    _item(
      context,
      Icons.person,
      'Modifier mon profil',
      () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
    ),
    Divider(height: 1, color: Theme.of(context).dividerColor),
    _item(
      context,
      Icons.logout,
      tr('account.sign_out'),
      () async => ref.read(authServiceProvider).signOut(),
      color: Colors.red,
    ),
    _item(
      context,
      Icons.cloud_upload_rounded,
      'Seed Test Data',
      () async => _seedAction(
        context,
        () => FirestoreSeederService().seedUsers(),
        'Seeding...',
        'Seeding complete!',
      ),
      color: AppColors.brand,
    ),
    _item(
      context,
      Icons.stadium,
      'Seed Clubs & Slots (10)',
      () async => _seedAction(
        context,
        () => FirestoreSeederService().seedClubsAndSlots(),
        'Seeding Clubs...',
        'Club Seeding complete!',
      ),
      color: AppColors.brand,
    ),
    _item(
      context,
      Icons.emoji_events,
      'Seed Events (10)',
      () async => _seedAction(
        context,
        () => FirestoreSeederService().seedEvents(),
        'Seeding Events...',
        'Events Seeding complete!',
      ),
      color: AppColors.brand,
    ),
  ];
}

Future<void> _seedAction(
  BuildContext context,
  Future<void> Function() action,
  String start,
  String done,
) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(start)));
  await action();
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
  }
}

Widget _item(
  BuildContext context,
  IconData icon,
  String label,
  VoidCallback onTap, {
  Color? color,
}) {
  final cs = Theme.of(context).colorScheme;
  return ListTile(
    leading: Icon(icon, color: color ?? cs.onSurfaceVariant),
    title: Text(
      label,
      style: TextStyle(
        color: color ?? cs.onSurface,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(
      Icons.chevron_right,
      size: 20,
      color: cs.onSurface.withValues(alpha: 0.3),
    ),
    onTap: onTap,
  );
}
