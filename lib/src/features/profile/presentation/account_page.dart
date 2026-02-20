import 'package:coco/src/core/providers.dart';
import 'package:coco/src/features/clubs/application/club_providers.dart';
import 'package:coco/src/features/clubs/domain/models/club_entity.dart';
import 'package:coco/src/features/clubs/presentation/pages/club_dashboard_screen.dart';
import 'package:coco/src/features/filters/application/firestore_seeder_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_profile_screen.dart';

part 'account_page_actions.part.dart';

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
                FutureBuilder<List<ClubEntity>>(
                  future: clubRepo.getClubsByOwnerId(user.uid),
                  builder: _buildClubSection,
                ),
                const SizedBox(height: 24),
                ...buildAccountActions(context, ref),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildClubSection(
    BuildContext context,
    AsyncSnapshot<List<ClubEntity>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Erreur club: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: _clubCard(context, snapshot.data!.first),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _clubCard(BuildContext context, ClubEntity club) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ClubDashboardScreen(clubId: club.id)),
      ),
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
}
