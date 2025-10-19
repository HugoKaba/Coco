import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:sportlinker/src/l10n/localization.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final loc = AppLocalizations.of(context);

    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('settings_title')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(loc.t('dark_theme')),
              value: isDark,
              onChanged: (v) => ref.read(isDarkModeProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),
            Text(
              loc.t('language'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentLocale == 'en'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onPressed: () =>
                      ref.read(localeProvider.notifier).state = 'en',
                  child: Text(
                    'EN',
                    style: TextStyle(
                      color: currentLocale == 'en' ? Colors.white : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentLocale == 'fr'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onPressed: () =>
                      ref.read(localeProvider.notifier).state = 'fr',
                  child: Text(
                    'FR',
                    style: TextStyle(
                      color: currentLocale == 'fr' ? Colors.white : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
