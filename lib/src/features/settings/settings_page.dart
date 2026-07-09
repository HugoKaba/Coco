import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coco/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('settings.title')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('settings.theme'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto),
                  label: Text(tr('settings.theme_system')),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode),
                  label: Text(tr('settings.theme_light')),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode),
                  label: Text(tr('settings.theme_dark')),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (sel) =>
                  ref.read(themeModeProvider.notifier).state = sel.first,
            ),
            const SizedBox(height: 24),
            Text(
              tr('settings.language'),
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
                  onPressed: () async {
                    try {
                      await context.setLocale(const Locale('en'));
                    } catch (_) {}
                    ref.read(localeProvider.notifier).state = 'en';
                  },
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
                  onPressed: () async {
                    try {
                      await context.setLocale(const Locale('fr'));
                    } catch (_) {}
                    ref.read(localeProvider.notifier).state = 'fr';
                  },
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
