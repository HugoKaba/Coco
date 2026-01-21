import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/providers.dart';
import '../../filters/application/firestore_seeder_service.dart';
import 'widgets/debug_account_info.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(tr('account.title')),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not authenticated'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                DebugAccountInfo(user: user),
                _buildItem(
                  context: context,
                  icon: Icons.settings,
                  label: tr('account.settings'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                _buildItem(
                  context: context,
                  icon: Icons.logout,
                  label: tr('account.sign_out'),
                  color: Colors.red,
                  onTap: () async {
                    final authService = ref.read(authServiceProvider);
                    await authService.signOut();
                  },
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
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
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
      leading: Icon(icon, color: color ?? const Color(0xFFD4913D)),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
