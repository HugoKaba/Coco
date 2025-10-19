import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:sportlinker/src/l10n/localization.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final loc = AppLocalizations.of(context);
    final user = ref
        .watch(authStateChangesProvider)
        .maybeWhen(data: (u) => u, orElse: () => null);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('home_title')),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
            ),
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: Text(loc.t('sign_out_button')),
          onPressed: () async {
            await auth.signOut();
          },
        ),
      ),
    );
  }
}
