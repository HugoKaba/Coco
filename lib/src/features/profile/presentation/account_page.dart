import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coco/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../filters/application/firestore_seeder_service.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(tr('account.title')),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem(
            context: context,
            icon: Icons.settings,
            label: tr('account.settings'),
            onTap: () => context.push('/settings'),
          ),
          _buildItem(
            context: context,
            icon: Icons.cloud_upload_rounded,
            label: 'Seed Test Data',
            onTap: () async {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Seeding...')));
              await FirestoreSeederService().seedUsers();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seeding complete!')),
                );
              }
            },
            color: const Color(0xFFD4913D),
          ),
          _buildItem(
            context: context,
            icon: Icons.logout,
            label: tr('account.sign_out'),
            onTap: () async => await auth.signOut(),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
