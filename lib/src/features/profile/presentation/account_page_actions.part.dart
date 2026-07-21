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
      tr('account.edit_profile'),
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
    // Données de démo (dev) : regroupées sur leur propre page pour ne pas
    // encombrer la liste du compte.
    _item(
      context,
      Icons.dataset,
      tr('account.seed.title'),
      () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SeederPage())),
      color: AppColors.brand,
    ),
  ];
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
