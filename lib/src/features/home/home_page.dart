import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final user = ref
        .watch(authStateChangesProvider)
        .maybeWhen(data: (u) => u, orElse: () => null);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('home.title')),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
            ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/account'),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: Text(tr('home.sign_out_button')),
          onPressed: () async {
            await auth.signOut();
          },
        ),
      ),
    );
  }
}
