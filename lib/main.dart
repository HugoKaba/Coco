import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sportlinker/src/router.dart';
import 'package:sportlinker/src/l10n/localization.dart';
import 'package:sportlinker/src/core/providers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: AppRoot()));
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});
  static bool _settingsInitScheduled = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    if (!_settingsInitScheduled) {
      _settingsInitScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(settingsInitProvider.future).catchError((_) {});
        ref.read(settingsPersistenceProvider);
      });
    }

    final isDark = ref.watch(isDarkModeProvider);
    final localeCode = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).t('app_title'),
      supportedLocales: const [Locale('en'), Locale('fr')],
      localeResolutionCallback: (locale, supportedLocales) {
        final appLocale = Locale(localeCode);
        if (supportedLocales.contains(appLocale)) return appLocale;
        return locale ?? supportedLocales.first;
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(localeCode),
      routerConfig: router,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const ProviderScope(child: AppRoot());
}
