import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../filters/application/firestore_seeder_service.dart';

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
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4913D).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD4913D),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DEBUG - Compte Connecté',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4913D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('User ID', user.uid),
                      _buildInfoRow('Email', user.email ?? 'Non défini'),
                      _buildInfoRow(
                        'Display Name',
                        user.displayName ?? 'Non défini',
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users_test')
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('Chargement...');
                          }
                          final data =
                              snapshot.data?.data() as Map<String, dynamic>?;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                'Prénom',
                                data?['firstName'] ?? 'Non défini',
                              ),
                              _buildInfoRow(
                                'Nom',
                                data?['lastName'] ?? 'Non défini',
                              ),
                              _buildInfoRow(
                                'Username',
                                data?['username'] ?? 'Non défini',
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
              },
              child: Text(
                value,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
