import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/providers.dart';
import '../../clubs/application/club_providers.dart';
import '../../clubs/domain/models/club_entity.dart';
import '../../clubs/presentation/pages/club_dashboard_screen.dart';

import '../../filters/application/firestore_seeder_service.dart';
import 'edit_profile_screen.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(tr('account.title')),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not authenticated'));
          }

          final clubRepo = ref.watch(clubRepositoryProvider);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Section Info Utilisateur - HIDDEN
                /*
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Compte Utilisateur',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCD8232),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Email', user.email ?? 'Non défini'),
                      // Add more user info here if needed
                    ],
                  ),
                ),
                */

                // Section Club (FutureBuilder)
                FutureBuilder<List<ClubEntity>>(
                  future: clubRepo.getClubsByOwnerId(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Erreur club: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final club = snapshot.data!.first;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: _buildClubCard(context, club),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 24),

                // Menu Items
                _buildItem(
                  context: context,
                  icon: Icons.settings,
                  label: tr('account.settings'),
                  onTap: () {},
                ),
                _buildItem(
                  context: context,
                  icon: Icons.person,
                  label: 'Modifier mon profil',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: Colors.white10),
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
                _buildItem(
                  context: context,
                  icon: Icons.stadium,
                  label: 'Seed Clubs & Slots (10)',
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seeding Clubs...')),
                    );
                    await FirestoreSeederService().seedClubsAndSlots();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Club Seeding complete!')),
                      );
                    }
                  },
                  color: const Color(0xFFD4913D),
                ),
                _buildItem(
                  context: context,
                  icon: Icons.emoji_events,
                  label: 'Seed Events (10)',
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seeding Events...')),
                    );
                    await FirestoreSeederService().seedEvents();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Events Seeding complete!'),
                        ),
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

  Widget _buildClubCard(BuildContext context, ClubEntity club) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClubDashboardScreen(clubId: club.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFCD8232), Color(0xFFA05E15)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCD8232).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gérer mon Club',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
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
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: Colors.white24,
      ),
      onTap: onTap,
    );
  }
}
